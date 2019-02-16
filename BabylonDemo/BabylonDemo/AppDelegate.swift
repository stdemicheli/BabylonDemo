//
//  AppDelegate.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup window and navigation controller.
        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // Setup app coordinator which handles the app's navigation.
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        
        // Setup UI appearance.
        setupAppearance()
        
        return true
    }
    
    private func setupAppearance() {
        Appearance.setupNavBar()
        Appearance.setupViews()
    }

}

