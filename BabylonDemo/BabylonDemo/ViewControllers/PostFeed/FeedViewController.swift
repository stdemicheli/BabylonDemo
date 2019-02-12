//
//  FeedViewController.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 12.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FeedViewController: UIViewController {
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private let feedViewModel: FeedViewModel
    private let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        // TODO: Move to coordinator
        let loader = FeedLoader(api: FeedAPI(), store: FeedStore())
        self.feedViewModel = FeedViewModel(loader: loader)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }
    
    private func bindToViewModel() {
        // Combine observables for initial fetch and refresh.
        let fetchPosts = PublishSubject<Void>()
        // TODO: Change to refresh control.
        let refreshPosts = barButton.rx.tap
        let fetchObservable = Observable.of(fetchPosts.asObservable(), refreshPosts.asObservable()).merge()
        
        // Setup view model input and generate output.
        let input = FeedViewModel.Input(fetch: fetchObservable)
        let output = feedViewModel.transform(input: input)
        
        // Bind tableview to the view model's output.
        output.posts
            .drive(tableView.rx.items) {
                (tableView: UITableView, index: Int, element: String) in
                let cell = UITableViewCell(style: .default, reuseIdentifier: "PostCell")
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: disposeBag)
        
        // Trigger initial fetch.
        fetchPosts.onNext(())
    }

}
