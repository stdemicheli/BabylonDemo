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
 A loader service for loading data to be displayed on the feed and post details.
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
    
    init(api: FeedAPIProtocol, store: FeedPersistenceStoreProtocol = FeedStore.shared) {
        self.feedAPI = api
        self.feedStore = store
        self.posts = Observable.empty()
        self.comments = Observable.empty()
        self.users = Observable.empty()
        self.error = Variable(FeedError(type: .none))
        
        setupOutput()
    }
    
    /// Sets up output to be consumed by view models.
    private func setupOutput() {
        // Load posts from the local store in a background context.
        let backgroundContext = feedStore.container.newBackgroundContext()
        let postsFromStore: [Post] = feedStore.load(recent: 100, in: backgroundContext)
        let commentsFromStore: [Comment] = feedStore.load(recent: 500, in: backgroundContext)
        let usersFromStore: [User] = feedStore.load(recent: 10, in: backgroundContext)
        
        // Setup observables subscribed to by view models.
        posts = loadPosts(with: postsFromStore, in: backgroundContext)
        comments = loadComments(with: commentsFromStore, in: backgroundContext)
        users = loadUsers(with: usersFromStore, in: backgroundContext)
    }
    
    // MARK: - Feed loader
    
    /// Loads posts from the network and persists them locally. On error, returns locally persisted posts.
    func loadPosts(with postsFromStore: [Post], in context: NSManagedObjectContext) -> Observable<[Post]> {
        return feedAPI.loadPosts()
            .flatMap { postRepresentations -> Observable<[Post]> in
                // Converts post representations to post models and persists them locally.
                let posts = Post.convert(from: postRepresentations, in: context)
                return Observable<[Post]>.from(optional: posts)
            }
            .startWith(postsFromStore)
            .share(replay: 1, scope: .whileConnected)
            .retryWhen { error in
                // Retries on error. Delays retry after each attempt.
                return error.enumerated().flatMap { (attempt, error) -> Observable<Int> in
                    let maxAttempts = 3
                    
                    if attempt >= maxAttempts - 1 {
                        // Notify subscribers about the error.
                        if let feedError = error as? FeedError.Types {
                            self.error.value = FeedError(type: feedError)
                        }
                    }
                    // Return a timer which increases delay after each attempt.
                    return Observable<Int>.timer(Double(attempt * 2), scheduler: MainScheduler.instance).take(1)
                }
            }
    }
    
    /// Loads comments from the network and persists them locally. On error, returns locally persisted comments.
    func loadComments(with commentsFromStore: [Comment], in context: NSManagedObjectContext) -> Observable<[Comment]> {
        return feedAPI.loadComments()
            .flatMap { commentRepresentations -> Observable<[Comment]> in
                // Converts comment representations to comment models and persists them locally.
                let comments = Comment.convert(from: commentRepresentations, in: context)
                return Observable.from(optional: comments)
            }
            .share(replay: 1, scope: .whileConnected)
            .catchError { error in
                // Notify subscribers about the error.
                if let feedError = error as? FeedError.Types {
                    self.error.value = FeedError(type: feedError)
                }
                // Return locally persisted objects.
                return Observable.from(optional: commentsFromStore)
            }
    }
    
    /// Loads users from the network and persists them locally. On error, returns locally persisted users.
    func loadUsers(with usersFromStore: [User], in context: NSManagedObjectContext) -> Observable<[User]> {
        return feedAPI.loadUsers()
            .flatMap { userRepresentations -> Observable<[User]> in
                // Converts user representations to user models and persists them locally.
                let users = User.convert(from: userRepresentations, in: context)
                return Observable.from(optional: users)
            }
            .share(replay: 1, scope: .whileConnected)
            .catchError { error in
                // Notify subscribers about the error.
                if let feedError = error as? FeedError.Types {
                    self.error.value = FeedError(type: feedError)
                }
                // Return locally persisted objects.
                return Observable.from(optional: usersFromStore)
            }
    }
    
}
