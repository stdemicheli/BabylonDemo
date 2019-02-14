//
//  AppCoordinator.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 13.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import UIKit

protocol AppCoordinatorDelegate: class {
    func didTapOnPost(with postId: Int, userId: Int)
}

class AppCoordinator: AppCoordinatorDelegate {
    
    weak var delegate: AppCoordinatorDelegate?
    let navigationController: UINavigationController
    let feedLoader: FeedLoader
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        let feedAPI = FeedAPI()
        let feedStore = FeedStore()
        feedLoader = FeedLoader(api: feedAPI, store: feedStore)
        
        setupViews()
    }
    
    // MARK: - Navigation
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedViewModel = FeedViewModel(loader: feedLoader)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "Feed") as! FeedViewController
        feedViewController.feedViewModel = feedViewModel
        feedViewController.appCoordinatorDelegate = self
        
        navigationController.pushViewController(feedViewController, animated: true)
    }
    
    func showPostDetails(for postId: Int, userId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postDetailViewModel = PostDetailViewModel(loader: feedLoader, postId: postId, userId: userId)
        let postDetailViewController = storyboard.instantiateViewController(withIdentifier: "PostDetail") as! PostDetailViewController
        postDetailViewController.postDetailViewModel = postDetailViewModel
        
        navigationController.pushViewController(postDetailViewController, animated: true)
    }
    
    // MARK: - AppCoordinatorDelegate
    
    func didTapOnPost(with postId: Int, userId: Int) {
        showPostDetails(for: postId, userId: userId)
    }
    
    // MARK: - Setup
    
    func setupViews() {
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
}
