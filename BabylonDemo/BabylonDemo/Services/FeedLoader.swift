//
//  FeedLoader.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

/**
 The loader service for loading data to be displayed on the feed and post details.
 */

class FeedLoader {
    
    // MARK: - Properties
    
    private let feedAPI: FeedAPIProtocol
    private let feedStore: FeedPersistenceStoreProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    
    // MARK: - Output
    
    let posts: Observable<[Post]>
    let comments: Observable<[Comment]>
    let users: Observable<[User]>
    
    // MARK: - Init
    
    init(api: FeedAPIProtocol, store: FeedPersistenceStoreProtocol) {
        self.feedAPI = api
        self.feedStore = store
        
        let backgroundContext = store.container.newBackgroundContext()
        let postsFromStore: [Post] = store.load(recent: 100, in: backgroundContext)
        posts = FeedLoader.loadPosts(from: api, combineWith: postsFromStore, in: backgroundContext)
        comments = FeedLoader.loadComments(from: api)
        users = FeedLoader.loadUsers(from: api)
    }
    
    // MARK: - Network requests
    
    static func loadPosts(from api: FeedAPIProtocol, combineWith postsFromStore: [Post], in context: NSManagedObjectContext) -> Observable<[Post]> {
        let maxAttempts = 3
        
        return api.loadPosts()
            .flatMap { postRepresentations -> Observable<[Post]> in
                let syncedPosts = try syncPersistentStore(postsFromStore, with: postRepresentations, in: context)
                return syncedPosts
            }
            .share(replay: 1, scope: .whileConnected)
            // Retries on error. Delays retry with each succession.
            .retryWhen { error in
                return error.enumerated().flatMap { (attempt, error) -> Observable<Int> in
                    if attempt >= maxAttempts - 1 {
                        return Observable.error(error)
                    }
                    return Observable<Int>.timer(Double(attempt * 2), scheduler: MainScheduler.instance).take(1)
                }
            }
            .catchError { error in
                return Observable.from(optional: postsFromStore)
            }
    }
    
    static func loadComments(from api: FeedAPIProtocol) -> Observable<[Comment]> {
        return api.loadComments()
            // Map JSON representation to Core Data model.
            .flatMap { commentRepresentations -> Observable<[Comment]> in
                let comments = Comment.convert(from: commentRepresentations)
                return Observable.from(optional: comments)
            }
            .share(replay: 1, scope: .whileConnected)
    }
    
    static func loadUsers(from api: FeedAPIProtocol) -> Observable<[User]> {
        return api.loadUsers()
            // Map JSON representation to Core Data model.
            .flatMap { userRepresentations -> Observable<[User]> in
                let users = User.convert(from: userRepresentations)
                return Observable.from(optional: users)
            }
            .share(replay: 1, scope: .whileConnected)
    }
    
    // MARK: - Local persistence
    
    static func syncPersistentStore(_ store: [Post], with postRepresentations: [PostRepresentation], in context: NSManagedObjectContext) throws -> Observable<[Post]>  {
        var error: Error?
        let postIds = Set(store.map { Int($0.identifier) })
        var posts = store
        
        for postRepresentation in postRepresentations {
            if !postIds.contains(postRepresentation.identifier) {
                let post = Post(postRepresentation: postRepresentation, context: context)
                posts.insert(post, at: 0)
            }
        }
        
        do {
            try FeedStore.shared.save(context: context)
        } catch let syncError {
            NSLog("Error syncing with persistent store: \(syncError)")
            error = syncError
        }
        
        if let error = error { throw error } else {
            return Observable.from(optional: posts)
        }
    }
    
}
