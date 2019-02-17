//
//  MockAPI.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 17.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import RxSwift

/**
 A mock network service used for UI testing purposes.
 */

struct MockAPI: FeedAPIProtocol {
    
    // MARK: - Properties
    
    let dataLoader: DataLoaderProtocol
    
    // MARK: - Init
    
    init(dataLoader: DataLoaderProtocol = URLSession.shared) {
        self.dataLoader = dataLoader
    }
    
    // MARK: - Network request methods
    
    /// A mock request which returns injected test data.
    func loadPosts() -> Observable<[PostRepresentation]> {
        do {
            let posts = try JSONDecoder().decode([PostRepresentation].self, from: TestData.validPostJSON)
            return Observable<[PostRepresentation]>.from(optional: posts)
        } catch {
            NSLog("Error decoding data: \(error)")
            return Observable.empty()
        }
    }
    
    /// A mock request which returns injected test data.
    func loadComments() -> Observable<[CommentRepresentation]> {
        do {
            let comments = try JSONDecoder().decode([CommentRepresentation].self, from: TestData.validCommentJSON)
            return Observable<[CommentRepresentation]>.from(optional: comments)
        } catch {
            NSLog("Error decoding data: \(error)")
            return Observable.empty()
        }
    }

    /// A mock request which returns injected test data.
    func loadUsers() -> Observable<[UserRepresentation]> {
        do {
            let users = try JSONDecoder().decode([UserRepresentation].self, from: TestData.validUserJSON)
            return Observable<[UserRepresentation]>.from(optional: users)
        } catch {
            NSLog("Error decoding data: \(error)")
            return Observable.empty()
        }
    }
    
    
}

