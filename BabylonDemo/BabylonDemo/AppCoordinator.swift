//
//  AppCoordinator.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 13.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import UIKit

/**
 A protocol through which the app coordinator gets informed about relevant user actions that should trigger navigation.
 */

protocol AppCoordinatorDelegate: class {
    func didTapOnPost(with postId: Int, userId: Int)
}

/**
 An app coordinator that handles the navigation of the app.
 */

class AppCoordinator: AppCoordinatorDelegate {
    
    weak var delegate: AppCoordinatorDelegate?
    let navigationController: UINavigationController
    let feedLoader: FeedLoader
    
    init(navigationController: UINavigationController, feedAPI: FeedAPIProtocol = FeedAPI()) {
        self.navigationController = navigationController

        // Use a mock feed loader for UI testing.
        if isUITesting {
            feedLoader = FeedLoader(api: MockAPI())
        } else {
            feedLoader = FeedLoader(api: feedAPI)
        }
        
        setupNavigationController()
    }
    
    // MARK: - Navigation
    
    /// Starts the app with a feed view controller.
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedViewModel = FeedViewModel(loader: feedLoader)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "Feed") as! FeedViewController
        feedViewController.feedViewModel = feedViewModel
        feedViewController.appCoordinatorDelegate = self
        
        navigationController.pushViewController(feedViewController, animated: true)
    }
    
    /// Shows a post's detail.
    func showPostDetails(for postId: Int, userId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postDetailViewModel = PostDetailViewModel(loader: feedLoader, postId: postId, userId: userId)
        let postDetailViewController = storyboard.instantiateViewController(withIdentifier: "PostDetail") as! PostDetailViewController
        postDetailViewController.postDetailViewModel = postDetailViewModel
        
        navigationController.pushViewController(postDetailViewController, animated: true)
    }
    
    // MARK: - AppCoordinatorDelegate
    
    /// Handles event where user taps on a post.
    func didTapOnPost(with postId: Int, userId: Int) {
        showPostDetails(for: postId, userId: userId)
    }
    
    // MARK: - Setup
    
    func setupNavigationController() {
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = UIColor.cream
    }
    
}
