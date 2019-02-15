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
    
    // MARK: - Output
    
    var posts: Observable<[Post]>
    var comments: Observable<[Comment]>
    var users: Observable<[User]>
    var error: Variable<FeedError>
    
    // MARK: - Init
    
    init(api: FeedAPIProtocol, store: FeedPersistenceStoreProtocol) {
        self.feedAPI = api
        self.feedStore = store
        self.posts = Observable.empty()
        self.comments = Observable.empty()
        self.users = Observable.empty()
        self.error = Variable(FeedError(type: .none))
        
        setupOutput()
    }
    
    /// Setup of output to be consumed by view models.
    private func setupOutput() {
        // Load posts from the local store in a background context.
        let backgroundContext = feedStore.container.newBackgroundContext()
        let postsFromStore: [Post] = feedStore.load(recent: 100, in: backgroundContext)
        
        // Setup observables subscribed to by view models.
        posts = loadPosts(with: postsFromStore, in: backgroundContext)
        comments = loadComments()
        users = loadUsers()
    }
    
    // MARK: - Feed loader
    
    /// Loads posts from the network and then synchronizes with local store.
    func loadPosts(with postsFromStore: [Post], in context: NSManagedObjectContext) -> Observable<[Post]> {
        return feedAPI.loadPosts()
            .flatMap { [weak self] postRepresentations -> Observable<[Post]> in
                let syncedPosts = try self?.syncPersistentStore(postsFromStore, with: postRepresentations, in: context)
                return syncedPosts ?? Observable.from(optional: postsFromStore)
            }
            .share(replay: 1, scope: .whileConnected)
            .catchError { error in
                if let feedError = error as? FeedError.Types {
                    self.error.value = FeedError(type: feedError)
                }
                return Observable.from(optional: postsFromStore)
            }
    }
    
    /// Loads comments from the network.
    func loadComments() -> Observable<[Comment]> {
        return feedAPI.loadComments()
            // Map JSON representation to Core Data model.
            .flatMap { commentRepresentations -> Observable<[Comment]> in
                let comments = Comment.convert(from: commentRepresentations)
                return Observable.from(optional: comments)
            }
            .share(replay: 1, scope: .whileConnected)
            .catchError { error in
                if let feedError = error as? FeedError.Types {
                    self.error.value = FeedError(type: feedError)
                }
                return Observable.from(optional: [])
            }
    }
    
    /// Loads users from the network.
    func loadUsers() -> Observable<[User]> {
        return feedAPI.loadUsers()
            // Map JSON representation to Core Data model.
            .flatMap { userRepresentations -> Observable<[User]> in
                let users = User.convert(from: userRepresentations)
                return Observable.from(optional: users)
            }
            .share(replay: 1, scope: .whileConnected)
            .catchError { error in
                if let feedError = error as? FeedError.Types {
                    self.error.value = FeedError(type: feedError)
                }
                return Observable.from(optional: [])
            }
    }
    
    // MARK: - Private methods
    
    /// Synchronizes fetched JSON post representations with posts fetched from the local store.
    private func syncPersistentStore(_ store: [Post], with postRepresentations: [PostRepresentation], in context: NSManagedObjectContext) throws -> Observable<[Post]>  {
        var error: Error?
        let postIds = Set(store.map { Int($0.identifier) })
        var posts = store
        
        // Check if post representation already exists in our local store.
        for postRepresentation in postRepresentations {
            if !postIds.contains(postRepresentation.identifier) {
                // Create a new post if we haven't previously saved it and add it to the front of the array as the most recent post.
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
