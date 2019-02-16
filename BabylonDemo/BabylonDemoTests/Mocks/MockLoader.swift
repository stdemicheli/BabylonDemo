//
//  MockLoader.swift
//  BabylonDemoTests
//
//  Created by De MicheliStefano on 12.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

@testable import BabylonDemo

class MockLoader: DataLoaderProtocol {
    
    init(data: Data? = nil, error: Error? = nil) {
        self.data = data
        self.error = error
    }
    
    var data: Data?
    var error: Error?
    private(set) var request: URLRequest? = nil
    private(set) var url: URL? = nil
        
    func loadData(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        return URLSessionDataTaskMock(closure: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(self.data, nil, self.error)
            }
        })
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        return URLSessionDataTaskMock(closure: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(self.data, nil, self.error)
            }
        })
    }
    
}

class URLSessionDataTaskMock: URLSessionDataTask {
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
    
    override func cancel() { }
    
}

class MockFeedLoader: FeedLoader {
    
    var shouldThrowError = false
    
    override func loadPosts(with postsFromStore: [Post], in context: NSManagedObjectContext) -> Observable<[Post]> {
        return shouldThrowError
            ? Observable.error(FeedError.Types.noConnection)
            : Observable.from(optional: [TestData.PostDetail.testPost])
    }
    
    override func loadComments(with commentsFromStore: [Comment], in context: NSManagedObjectContext) -> Observable<[Comment]> {
        return shouldThrowError
            ? Observable.error(FeedError.Types.noConnection)
            : Observable.from(optional: [TestData.PostDetail.testComment])
    }
    
    override func loadUsers(with usersFromStore: [User], in context: NSManagedObjectContext) -> Observable<[User]> {
        return shouldThrowError
            ? Observable.error(FeedError.Types.noConnection)
            : Observable.from(optional: [TestData.PostDetail.testUser])
    }
}
