//
//  main.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 15.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import UIKit

/// Creates application object with either the AppDelegate or a TestingAppDelegate.
let appDelegateClass: AnyClass =
    NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(appDelegateClass)
)
