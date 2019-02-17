//
//  FeedPage.swift
//  BabylonDemoUITests
//
//  Created by De MicheliStefano on 17.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import XCTest

struct FeedPage: TestPage {
    
    var testCase: XCTestCase
    
    // MARK: - UI Elements
    
    // Feed
    
    func postCell(for index: Int) -> XCUIElement {
        return app.tables.cells.element(boundBy: index)
    }
    
    // PostDetails
    
    var authorLabel: XCUIElement {
        return app.staticTexts["PostDetail.AuthorLabel"]
    }
    
    var descriptionLabel: XCUIElement {
        return app.staticTexts["PostDetail.DescriptionLabel"]
    }
    
    var commentCountLabel: XCUIElement {
        return app.staticTexts["PostDetail.CommentCountLabel"]
    }
    
    var tapToShowMoreLabel: XCUIElement {
        return app.staticTexts["DetailsViewController.TapToShowMore"]
    }
    
    // MARK: - Actions (interactions)
    
    @discardableResult func tapOnPostCell(at index: Int, file: String = #file, line: UInt = #line) -> FeedPage {
        let cell = postCell(for: index)
        testCase.expect(exists: cell)
        cell.tap()
        return self
    }
    
    // MARK: - Verifications
    
    @discardableResult func verifyPostCellTitle(_ expectedTitle: String, at index: Int, file: String = #file, line: UInt = #line) -> FeedPage {
        let cell = postCell(for: index)
        let titleElement = cell.staticTexts.firstMatch
        testCase.expect(exists: titleElement)
        testCase.expect(titleElement.label, equals: expectedTitle)
        return self
    }
    
    @discardableResult func verifyAuthor(_ expectedAuthor: String, file: String = #file, line: UInt = #line) -> FeedPage {
        testCase.expect(exists: authorLabel)
        testCase.expect(authorLabel.label, equals: expectedAuthor)
        return self
    }
    
    @discardableResult func verifyDescription(_ expectedDescription: String, file: String = #file, line: UInt = #line) -> FeedPage {
        testCase.expect(exists: descriptionLabel)
        testCase.expect(descriptionLabel.label, equals: expectedDescription)
        return self
    }
    
    @discardableResult func verifyCommentCount(_ commentCount: String, file: String = #file, line: UInt = #line) -> FeedPage {
        testCase.expect(exists: commentCountLabel)
        testCase.expect(commentCountLabel.label, equals: commentCount)
        return self
    }
    
    @discardableResult func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) -> FeedPage {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        testCase.expectation(for: existsPredicate,
                             evaluatedWith: element, handler: nil)
        
        testCase.waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                NSLog("Failed to find \(element) after \(timeout) seconds.")
            }
        }
        
        return self
    }
    
}
