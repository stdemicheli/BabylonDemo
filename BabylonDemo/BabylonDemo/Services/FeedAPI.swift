//
//  BabylonAPI.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import RxSwift

/**
 The protocol for fetching feed data from the network.
 */

protocol FeedAPIProtocol {
    var dataLoader: DataLoader { get }
    func loadPosts() -> Observable<[PostRepresentation]>
    func loadComments() -> Observable<[CommentRepresentation]>
    func loadUsers() -> Observable<[UserRepresentation]>
}

/**
 The network service for fetching feed data from the server.
 */

struct FeedAPI: FeedAPIProtocol {
    
    /// An HTTP method type for type-safe http method configurations.
    private enum HTTPMethod: String {
        case post = "POST"
        case put = "PUT"
        case get = "GET"
        case delete = "DELETE"
    }
    
    // MARK: - Properties
    
    let baseUrl = URL(string: "http://jsonplaceholder.typicode.com/")!
    let dataLoader: DataLoader
    
    // MARK: - Init
    
    init(dataLoader: DataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
    }
    
    // MARK: - Network request methods
    
    /// A network request for loading posts.
    func loadPosts() -> Observable<[PostRepresentation]> {
        let url = self.url(pathComponents: ["posts"])
        return fetch(with: url)
    }
    
    /// A network request for loading comments.
    func loadComments() -> Observable<[CommentRepresentation]> {
        let url = self.url(pathComponents: ["comments"])
        return fetch(with: url)
    }
    
    /// A network request for loading users.
    func loadUsers() -> Observable<[UserRepresentation]> {
        let url = self.url(pathComponents: ["users"])
        return fetch(with: url)
    }
    
    // MARK: - Generic network requests
    
    /// A generic fetch request which returns a custom observable.
    private func fetch<Resource: Codable>(with url: URL) -> Observable<Resource> {
        return Observable.create({ observer in
            let dataTask = self.dataLoader.loadData(from: url) {data, res, error in
                if let error = error {
                    NSLog("Error with FETCH urlRequest: \(error)")
                    observer.onError(FeedError.Types.requestFailed)
                    return
                }
                
                guard let data = data else {
                    NSLog("No data returned")
                    observer.onError(FeedError.Types.requestFailed)
                    return
                }
                
                if let httpResponse = res as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        NSLog("An error code was returned from the http request: \(httpResponse.statusCode)")
                        observer.onError(FeedError.Types.requestFailed)
                        return
                    }
                }
                
                do {
                    let resource = try JSONDecoder().decode(Resource.self, from: data)
                    observer.onError(FeedError.Types.noConnection)
                    //observer.onNext(resource)
                } catch {
                    NSLog("Error decoding data: \(error)")
                    observer.onError(FeedError.Types.decodingFailed)
                    return
                }
            }
            dataTask.resume()
            
            return Disposables.create {
                dataTask.cancel()
            }
        })
    }
    
    /// A helper function for adding path components to the base url.
    private func url(pathComponents: [String], pathExtension: String? = nil) -> URL {
        var url = baseUrl
        pathComponents.forEach { url.appendPathComponent($0) }
        if let pathExtension = pathExtension { url.appendPathExtension(pathExtension) }
        return url
    }
    
}
