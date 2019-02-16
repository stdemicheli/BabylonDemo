//
//  FeedViewModel.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 12.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/**
 The feed view model that handles fetch events and returns posts.
     - Input: Fetch event
     - Output: List of posts
 */

class FeedViewModel: ViewModelType {
    
    // MARK: - Properties
    
    /// Refers to a view model to be consumed by the view.
    typealias ViewPost = (title: String, postId: Int, userId: Int)
    private let loader: FeedLoader
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    /// Input which listens for fetch events.
    struct Input {
        let fetch: Observable<Void>
    }
    
    // MARK: - Output
    
    /// Output which exposes an observable sequence of post arrays.
    struct Output {
        let posts: Observable<[ViewPost]>
        let error: Variable<FeedError>
    }
    
    // MARK: - Init
    
    init(loader: FeedLoader) {
        self.loader = loader
    }
    
    // MARK: - Public methods
    
    /// Transforms a fetch event to an observable sequence for posts.
    func transform(input: FeedViewModel.Input) -> FeedViewModel.Output {
        let posts = input.fetch
            // Load posts and return an empty observable if nil.
            .flatMap { [weak self] _ -> Observable<[Post]> in
                return self?.loader.posts ?? Observable<[Post]>.empty()
            }
            // Transform Post models into View Post models.
            .flatMap { posts -> Observable<[ViewPost]> in
                let viewPosts = posts.compactMap { (title: $0.title ?? "", postId: Int($0.identifier), userId: Int($0.userIdentifier)) }
                return Observable.from(optional: viewPosts)
            }
        
        let error = loader.error
        
        return Output(posts: posts, error: error)
    }
    
}
