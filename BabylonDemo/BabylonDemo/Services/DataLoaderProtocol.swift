//
//  DataLoader.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 12.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

/**
 A network data loader protocol and extension for loading data from network.
 The data loader protocol gives us the ability to inject mock data for our tests.
 */

protocol DataLoaderProtocol {
    func loadData(from request: URLRequest, completion: @escaping(Data?, URLResponse?,  Error?) -> Void) -> URLSessionDataTask
    func loadData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: DataLoaderProtocol {
    func loadData(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { (data, res, error) in
            completion(data, res, error)
        }
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, res, error) in
            completion(data, res, error)
        }
    }
}
