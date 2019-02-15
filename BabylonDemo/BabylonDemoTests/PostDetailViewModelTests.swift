//
//  PostDetailViewModelTests.swift
//  BabylonDemoTests
//
//  Created by De MicheliStefano on 15.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import XCTest
import RxSwift

@testable import BabylonDemo

class PostDetailViewModelTests: XCTestCase {
    
    var postDetailViewModel: PostDetailViewModel!
    var mockLoader: MockLoader!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        mockLoader = MockLoader()
        let testAPI = FeedAPI(dataLoader: mockLoader)
        let feedLoader = FeedLoader(api: testAPI, store: FeedStore())
        postDetailViewModel = PostDetailViewModel(loader: feedLoader, postId: 1, userId: 1)
    }
    
    override func tearDown() {
        postDetailViewModel = nil
        mockLoader = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_whenFetchingForPostDetails_handlesValidPostData() {
        // given
        mockLoader.data = TestData.Feed.validPostJSON
        let testSubject = PublishSubject<Void>()
        
        // when
        let input = PostDetailViewModel.Input(fetch: testSubject.asObservable())
        let output = postDetailViewModel.transform(input: input)
        
        output.postDetail.asObservable()
            .subscribe(onNext: { postDetail in // (author: String, description: String, commentCount: Int)
                // then
                XCTAssertNotNil(postDetail)
                //XCTAssertEqual(post.first, TestData.Feed.expectedTitle)
            })
            .disposed(by: disposeBag)
        
        testSubject.onNext(())
    }
    
    func test_whenFetchingForPostDetails_handlesInvalidPostData() {
        // given
        mockLoader.data = TestData.Feed.invalidPostJSON
        let testSubject = PublishSubject<Void>()
        
        // when
        let input = PostDetailViewModel.Input(fetch: testSubject.asObservable())
        let output = postDetailViewModel.transform(input: input)
        
        output.postDetail.asObservable()
            .subscribe(onNext: { postDetail in // (author: String, description: String, commentCount: Int)
                // then
                XCTAssertNotNil(postDetail)
                //XCTAssertTrue(post.isEmpty)
            })
            .disposed(by: disposeBag)
        
        testSubject.onNext(())
    }
    
    func test_whenInitialized_bindsPostDetails() {
        // given
        mockLoader.data = TestData.Feed.validPostJSON
        let testSubject = PublishSubject<Void>()

        // when
        let input = PostDetailViewModel.Input(fetch: testSubject.asObservable())
        let output = postDetailViewModel.transform(input: input)

        // then
        XCTAssertNotNil(output.postDetail)
    }
    
}
