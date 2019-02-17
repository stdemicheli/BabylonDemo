//
//  TestPage.swift
//  BabylonDemoUITests
//
//  Created by De MicheliStefano on 16.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import XCTest

protocol TestPage {
    var testCase: XCTestCase { get }
}

extension TestPage {
    var app: XCUIApplication {
        return XCUIApplication()
    }
}
