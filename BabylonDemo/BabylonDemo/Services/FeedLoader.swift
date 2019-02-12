//
//  FeedLoader.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
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
        
        // TODO: synchronize with local data store, and then save to disk
        
        /// Maps API responses to Feed objects (Post, Comment, User)
        // TODO: break into generic function:
        posts = api.loadPosts()
            .flatMap { postRepresentations -> Observable<[Post]> in
                let posts = Post.convert(from: postRepresentations)
                return Observable.from(optional: posts)
            }
            //.share(replay: 1, scope: .whileConnected)
        
        comments = api.loadComments()
            .flatMap { commentRepresentations -> Observable<[Comment]> in
                let comments = Comment.convert(from: commentRepresentations)
                return Observable.from(optional: comments)
            }
            .share(replay: 1, scope: .whileConnected)
        
        users = api.loadUsers()
            .flatMap { userRepresentations -> Observable<[User]> in
                let users = User.convert(from: userRepresentations)
                return Observable.from(optional: users)
            }
            .share(replay: 1, scope: .whileConnected)
    }
    
    // MARK: - Private methods
    
    
}
