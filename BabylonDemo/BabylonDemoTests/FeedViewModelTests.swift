//
//  FeedViewModelTests.swift
//  BabylonDemoTests
//
//  Created by De MicheliStefano on 12.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import XCTest
import CoreData
import RxSwift

@testable import BabylonDemo

class FeedViewModelTests: XCTestCase {
    
    // MARK: - Setup
    
    var feedViewModel: FeedViewModel!
    var mockLoader: MockLoader!
    var disposeBag = DisposeBag()
    
    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    /// A mock persistence container which uses a volatile, in-memory persistence storage component.
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataUnitTesting", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        super.setUp()
        
        mockLoader = MockLoader()
        
        let testAPI = FeedAPI(dataLoader: mockLoader)
        let testStore = FeedStore()
        testStore.container = mockPersistantContainer
        let feedLoader = FeedLoader(api: testAPI, store: testStore)
        
        feedViewModel = FeedViewModel(loader: feedLoader)
    }
    
    override func tearDown() {
        feedViewModel = nil
        mockLoader = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_whenFetchIsTriggered_handlesValidPostData() {
        // given
        mockLoader.data = TestData.Feed.validPostJSON
        let testSubject = PublishSubject<Void>()
        let expectation = self.expectation(description: "test_whenFetchIsTriggered_handlesInvalidPostData")
                
        // when
        let input = FeedViewModel.Input(fetch: testSubject.asObservable())
        let output = feedViewModel.transform(input: input)

        output.posts.asObservable()
            .subscribe(onNext: { post in
                guard let postTitle = post.first?.title else { return }
                
                // then
                XCTAssertNotNil(post)
                XCTAssertEqual(postTitle, TestData.Feed.expectedTitle)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        testSubject.onNext(())
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_whenFetchIsTriggered_handlesInvalidPostData() {
        // given
        mockLoader.data = TestData.Feed.invalidPostJSON
        let testSubject = PublishSubject<Void>()
        let expectation = self.expectation(description: "test_whenFetchIsTriggered_handlesInvalidPostData")
        
        // when
        let input = FeedViewModel.Input(fetch: testSubject.asObservable())
        let output = feedViewModel.transform(input: input)
        
        output.posts.asObservable()
            .subscribe(onNext: { post in
                // then
                XCTAssertNotNil(post)
                XCTAssertTrue(post.isEmpty)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        testSubject.onNext(())
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_whenErrorIsThrown_handlesErrors() {
        // given
        let feedError = FeedError(type: .noConnection)
        mockLoader.error = feedError.type
        
        let testSubject = PublishSubject<Void>()
        let expectation = self.expectation(description: "test_whenErrorIsThrown_handlesErrors")
        
        // when
        let input = FeedViewModel.Input(fetch: testSubject.asObservable())
        let output = feedViewModel.transform(input: input)
        
        output.posts.subscribe().disposed(by: disposeBag)
        output.error.asObservable()
            .observeOn(MainScheduler.instance)
            .filter { $0.type != .none }
            .take(1)
            .subscribe(onNext: { error in
                // then
                XCTAssertNotNil(feedError)
                XCTAssertEqual(feedError.type, TestData.PostDetail.expectedErrorType)
                XCTAssertEqual(feedError.message, TestData.PostDetail.expectedErrorMessage)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        testSubject.onNext(())
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test_whenInitialized_bindsPosts() {
        // given
        mockLoader.data = TestData.Feed.validPostJSON
        let testSubject = PublishSubject<Void>()
        
        // when
        let input = FeedViewModel.Input(fetch: testSubject.asObservable())
        let output = feedViewModel.transform(input: input)
        
        // then
        XCTAssertNotNil(output.posts)
        XCTAssertNotNil(output.error)
    }
        
}
