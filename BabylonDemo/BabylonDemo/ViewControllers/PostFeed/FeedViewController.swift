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
    
    // MARK: - Properties
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var feedViewModel: FeedViewModel?
    var appCoordinatorDelegate: AppCoordinatorDelegate?
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }
    
    // MARK: - Event handlers
    
    func bindToViewModel() {
        // Combine observables for initial fetch and refresh.
        let fetchPosts = PublishSubject<Void>()
        // TODO: Change to refresh control.
        let refreshPosts = barButton.rx.tap
        let fetchObservable = Observable.of(fetchPosts.asObservable(), refreshPosts.asObservable()).merge()
        
        // Setup view model input and generate output.
        let viewModelInput = FeedViewModel.Input(fetch: fetchObservable)
        guard let viewModelOutput = feedViewModel?.transform(input: viewModelInput) else { return }
        
        bindTableView(to: viewModelOutput)
        bindItemSelectedEvent(to: viewModelOutput)
        bindErrorEvent(to: viewModelOutput)
        
        // Trigger initial fetch.
        fetchPosts.onNext(())
    }
    
    private func bindTableView(to viewModelOutput: FeedViewModel.Output) {
        // Bind tableview to the view model's output.
        viewModelOutput.posts
            // Transform view model to a list of titles.
            .flatMap { viewPosts -> Observable<[String]> in
                let titles = viewPosts.map { $0.title }
                return Observable.from(optional: titles)
            }
            // TODO: Change
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) {
                (tableView: UITableView, index: Int, element: String) in
                let cell = UITableViewCell(style: .default, reuseIdentifier: "PostCell")
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func bindItemSelectedEvent(to viewModelOutput: FeedViewModel.Output) {
        // Handle selected item event.
        tableView.rx
            .itemSelected
            .withLatestFrom(viewModelOutput.posts.asObservable()) { (indexPath, posts) -> FeedViewModel.ViewPost in
                return posts[indexPath.row]
            }
            .subscribe({ [weak self] post in
                // Let app coordinator know that post was tapped and pass along post/user ids.
                if let post = post.element {
                    self?.appCoordinatorDelegate?.didTapOnPost(with: post.postId, userId: post.userId)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindErrorEvent(to viewModelOutput: FeedViewModel.Output) {
        viewModelOutput.error
            .asObservable()
            .observeOn(MainScheduler.instance)
            .filter { $0.type != .none }
            .take(1)
            .subscribe(onNext: { [weak self] error in
                self?.show(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI
    
    private func show(error: FeedError) {
        let errorView = ErrorView(message: error.message)
        errorView.show(in: self)
    }

}
