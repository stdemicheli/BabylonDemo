//
//  FeedUITests.swift
//  BabylonDemoUITests
//
//  Created by De MicheliStefano on 17.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import XCTest

class FeedUITests: XCTestCase {
    
    var feed: FeedPage!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["UITesting"]
        app.launch()
        
        feed = FeedPage(testCase: self)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_whenFeedIsLoaded_DisplaysExpectedPostCell() {
        feed
            .verifyPostCellTitle("test", at: 0)
    }
    
}
