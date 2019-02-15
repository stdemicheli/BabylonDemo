//
//  PostDetailViewModelTests.swift
//  BabylonDemoTests
//
//  Created by De MicheliStefano on 15.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import XCTest
import CoreData
import RxSwift

@testable import BabylonDemo

class PostDetailViewModelTests: XCTestCase {
    
    // MARK: - Setup
    
    var postDetailViewModel: PostDetailViewModel!
    var mockFeedLoader: MockFeedLoader!
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
        
        mockFeedLoader = MockFeedLoader(api: testAPI, store: testStore)
        postDetailViewModel = PostDetailViewModel(loader: mockFeedLoader, postId: 1, userId: 1)
    }
    
    override func tearDown() {
        postDetailViewModel = nil
        mockLoader = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_whenFetchingForPostDetails_handlesValidPostData() {
        // given
        let testSubject = PublishSubject<Void>()
        
        // when
        let input = PostDetailViewModel.Input(fetch: testSubject.asObservable())
        let output = postDetailViewModel.transform(input: input)
        let expectation = self.expectation(description: "test_whenFetchingForPostDetails_handlesValidPostData")
        
        output.postDetail.asObservable()
            .subscribe(onNext: { postDetail in
                // then
                XCTAssertNotNil(postDetail)
                XCTAssertEqual(postDetail.author, TestData.PostDetail.expectedAuthor)
                XCTAssertEqual(postDetail.description, TestData.PostDetail.expectedDescription)
                XCTAssertEqual(postDetail.commentCount, TestData.PostDetail.expectedNumberOfComments)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        testSubject.onNext(())
        
        waitForExpectations(timeout: 2.0, handler: nil)
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
