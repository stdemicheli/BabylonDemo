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

    
}
