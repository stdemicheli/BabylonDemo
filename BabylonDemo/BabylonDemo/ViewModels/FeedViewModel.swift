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

class FeedViewModel: ViewModelType {
    
    // MARK: - Properties
    
    typealias PostView = String
    
    private let loader: FeedLoader
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let fetch: Observable<Void>
    }
    
    
    // MARK: - Output
    
    struct Output {
        var posts: Driver<[PostView]>
    }
    
    // MARK: - Init
    
    init(loader: FeedLoader) {
        self.loader = loader
    }
    
    func transform(input: FeedViewModel.Input) -> FeedViewModel.Output {
        let posts = input.fetch
            .flatMap { [weak self] _ -> Observable<[Post]> in
                return self?.loader.posts ?? Observable<[Post]>.empty()
            }
            .flatMap { posts -> Observable<[PostView]> in
                let titles = posts.compactMap { $0.title }
                return Observable.from(optional: titles)
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(posts: posts)
    }
    
    // MARK: - Private methods
    
    
}
