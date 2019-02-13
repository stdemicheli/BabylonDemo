//
//  MockLoader.swift
//  BabylonDemoTests
//
//  Created by De MicheliStefano on 12.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

@testable import BabylonDemo

class MockLoader: DataLoader {
    
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    
    var data: Data?
    let error: Error?
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
