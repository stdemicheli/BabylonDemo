//
//  FeedViewModelTests.swift
//  BabylonDemoTests
//
//  Created by De MicheliStefano on 12.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import XCTest
import RxSwift

@testable import BabylonDemo

class FeedViewModelTests: XCTestCase {
    
    var feedViewModel: FeedViewModel!
    var feedLoader: FeedLoader!
    var testAPI: FeedAPIProtocol!
    var mockLoader: MockLoader!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        mockLoader = MockLoader(data: nil, error: nil)
        testAPI = FeedAPI(dataLoader: mockLoader)
        feedLoader = FeedLoader(api: testAPI, store: FeedStore())
        feedViewModel = FeedViewModel(loader: feedLoader)
    }
    
    override func tearDown() {
        feedLoader = nil
        testAPI = nil
        mockLoader = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_whenFetchIsTriggered_handlesValidPostData() {
        // given
        mockLoader.data = TestData.Feed.validPostJSON
        let testSubject = PublishSubject<Void>()
                
        // when
        let input = FeedViewModel.Input(fetch: testSubject.asObservable())
        let output = feedViewModel.transform(input: input)

        output.posts.asObservable()
            .subscribe(onNext: { post in
                // then
                XCTAssertNotNil(post)
                XCTAssertEqual(post.first, TestData.Feed.expectedTitle)
            })
            .disposed(by: disposeBag)
        
        testSubject.onNext(())
        
        // then
        XCTAssertNotNil(input)
        XCTAssertNotNil(output)
    }
    
    func test_whenFetchIsTriggered_handlesInvalidPostData() {
        // given
        mockLoader.data = TestData.Feed.invalidPostJSON
        let testSubject = PublishSubject<Void>()
        
        // when
        let input = FeedViewModel.Input(fetch: testSubject.asObservable())
        let output = feedViewModel.transform(input: input)
        
        output.posts.asObservable()
            .subscribe(onNext: { post in
                // then
                XCTAssertNotNil(post)
                XCTAssertTrue(post.isEmpty)
            })
            .disposed(by: disposeBag)
        
        testSubject.onNext(())
        
        // then
        XCTAssertNotNil(input)
        XCTAssertNotNil(output)
    }
    
    func test_whenInitialized_bindsPosts() {
        // given
        mockLoader.data = TestData.Feed.validPostJSON
        let testSubject = PublishSubject<Void>()
        
        // when
        let input = FeedViewModel.Input(fetch: testSubject.asObservable())
        let output = feedViewModel.transform(input: input)
        
        // then
        XCTAssertNotNil(output)
    }
        
}
