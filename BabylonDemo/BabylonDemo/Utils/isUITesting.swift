//
//  isUITesting.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 17.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

/**
 A helper variable which indicates if the app instance is in UI testing mode.
 */

var isUITesting: Bool {
    return CommandLine.arguments.contains("UITesting")
}
