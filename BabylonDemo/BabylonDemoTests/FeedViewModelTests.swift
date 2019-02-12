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
    
    func testExample() {
        // given
        mockLoader.data = TestData.validPostJSON
        let testSubject = PublishSubject<Void>()
                
        // when
        let input = FeedViewModel.Input(fetch: testSubject.asObservable())
        let output = feedViewModel.transform(input: input)
        
        
        // then
        XCTAssertNotNil(input)
        XCTAssertNotNil(output)
        
        
    }
        
}
