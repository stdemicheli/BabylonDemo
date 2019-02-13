//
//  PostDetailViewModel.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 13.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/**
 The post detail view model that handles fetch events and returns post details.
     - Input: Fetch event
     - Output: Post details
 */

class PostDetailViewModel: ViewModelType {
    
    // MARK: - Properties
    
    /// Refers to a view post detail model (consisting of a author, description, and number of comments) to be consumed by the view.
    typealias ViewPostDetail = (author: String, description: String, commentCount: Int)
    
    let postId: Variable<Int>
    let userId: Variable<Int>
    
    private let loader: FeedLoader
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    /// Input which listens for fetch events.
    struct Input {
        let fetch: Observable<Void>
    }
    
    // MARK: - Output
    
    /// Output which exposes an observable sequence for post details.
    struct Output {
        let postDetail: Observable<ViewPostDetail>
        //let postDetail: Driver<ViewPostDetail>
    }
    
    // MARK: - Init
    
    init(loader: FeedLoader, postId: Int, userId: Int) {
        self.loader = loader
        self.postId = Variable(postId)
        self.userId = Variable(userId)
    }
    
    // MARK: - Public methods
    
    /// Transforms a fetch event and returns an observable sequence for post details.
    func transform(input: PostDetailViewModel.Input) -> PostDetailViewModel.Output {
        let posts = loader.posts
        let comments = loader.comments
        let users = loader.users
        
        let postDetail = input.fetch
            // Return a combined observer once all feed observables have emitted new values.
            .flatMap { _ in
                return Observable.zip(posts, comments, users)
            }
            // Find user's name, the post body, and get the comment count.
            .flatMap { [weak self] feed -> Observable<ViewPostDetail> in
                // TODO: add loadPost to loader that shares the latest fetch instead of refetching
                let author = feed.2.first(where: { Int($0.identifier) == self?.userId.value })?.name
                let postBody = feed.0.first(where: { Int($0.identifier) == self?.postId.value })?.body
                let commentCount = feed.1.filter { Int($0.postIdentifier) == self?.postId.value }.count
                
                if let author = author, let postBody = postBody {
                    return Observable.of((author: author, description: postBody, commentCount: commentCount))
                } else {
                    throw ViewModelErrors.valueNotFound
                }
            }
            // TODO: handle error
            //.asDriver(onErrorJustReturn: (author: "", description: "", commentCount: 0))
        
        return Output(postDetail: postDetail)
    }
    
    // MARK: - Private methods
    
    
}
