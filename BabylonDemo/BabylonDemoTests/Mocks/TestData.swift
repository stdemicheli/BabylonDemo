//
//  TestData.swift
//  BabylonDemoTests
//
//  Created by De MicheliStefano on 12.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

@testable import BabylonDemo

struct TestData {
    
    struct Feed {
        
        static let validPostJSON = """
        [{
            "userId": 1,
            "id": 1,
            "title": "test",
            "body": "test"
        }]
        """.data(using: .utf8)!
        
        static let invalidPostJSON = """
        {
            "error": true
        }
        """.data(using: .utf8)!
        
        static let expectedTitle = "test"
        
    }
    
    struct PostDetail {
        
        static let validPostJSON = """
        [{
            "userId": 1,
            "id": 1,
            "title": "test",
            "body": "test"
        }]
        """.data(using: .utf8)!
        
        static let validCommentJSON = """
        [{
            "postId": 1,
            "id": 1,
            "name": "test",
            "email": "test@test.com",
            "body": "test"
        }]
        """.data(using: .utf8)!
        
        static let validUserJSON = """
        [{
            "id": 1,
            "name": "test",
            "username": "test",
            "email": "test@test.com",
            "address": {
              "street": "test",
              "suite": "test",
              "city": "test",
              "zipcode": "123",
              "geo": {
                "lat": "123",
                "lng": "123"
              }
            },
            "phone": "123",
            "website": "",
            "company": {
              "name": "Yost and Sons",
              "catchPhrase": "Switchable contextually-based project",
              "bs": "aggregate real-time technologies"
            }
        }]
        """.data(using: .utf8)!
        
        static let invalidJSON = """
        {
            "error": true
        }
        """.data(using: .utf8)!
        
        static let testPost = Post(identifier: 1, userIdentifier: 1, title: "test", body: "test")
        static let testComment = Comment(identifier: 1, postIdentifier: 1, name: "test", body: "test", email: "test")
        static let testUser = User(identifier: 1, name: "test", username: "test", email: "test")
        
        static let expectedAuthor = "test"
        static let expectedDescription = "test"
        static let expectedNumberOfComments = 1
        static let expectedErrorMessage = "No internet connection."
        static let expectedErrorType = FeedError.Types.noConnection
        
    }

    
}
