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
    
    /// Refers to a view post model (consisting of a title) to be consumed by the view.
    typealias ViewPost = String
    private let loader: FeedLoader
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    /// Input which listens for fetch events.
    struct Input {
        let fetch: Observable<Void>
    }
    
    // MARK: - Output
    
    /// Output which exposes an observable sequence for posts.
    struct Output {
        let posts: Driver<[ViewPost]>
    }
    
    // MARK: - Init
    
    init(loader: FeedLoader) {
        self.loader = loader
    }
    
    // MARK: - Public methods
    
    /// Transforms a fetch event and returns an observable sequence for posts.
    func transform(input: FeedViewModel.Input) -> FeedViewModel.Output {
        let posts = input.fetch
            // Load posts and return an empty observable if nil.
            .flatMap { [weak self] _ -> Observable<[Post]> in
                return self?.loader.posts ?? Observable<[Post]>.empty()
            }
            // Transform Post models into View Post models.
            .flatMap { posts -> Observable<[ViewPost]> in
                let titles = posts.compactMap { $0.title }
                return Observable.from(optional: titles)
            }
            // Handle errors gracefully by returning an empty array.
            .asDriver(onErrorJustReturn: [])
        
        return Output(posts: posts)
    }
    
}
