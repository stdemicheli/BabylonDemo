//
//  TestData.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 17.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

/**
 Test data which is injected into the mock API service.
 */

struct TestData {
    
    static let validPostJSON = """
        [{
            "userId": 0,
            "id": 0,
            "title": "test",
            "body": "test"
        }]
        """.data(using: .utf8)!
    
    static let validCommentJSON = """
        [{
            "postId": 0,
            "id": 0,
            "name": "test",
            "email": "test@test.com",
            "body": "test"
        }]
        """.data(using: .utf8)!
    
    static let validUserJSON = """
        [{
            "id": 0,
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
    
    static let expectedTitle = "test"
    static let expectedAuthor = "test"
    static let expectedDescription = "test"
    static let expectedCommentCount = "1 comment"
    
}
