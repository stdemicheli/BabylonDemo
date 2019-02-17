//
//  isUITesting.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 17.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

var isUITesting: Bool {
    return CommandLine.arguments.contains("UITesting")
}
