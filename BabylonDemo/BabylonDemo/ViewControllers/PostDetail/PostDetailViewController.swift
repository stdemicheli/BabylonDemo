//
//  PostDetailViewController.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 13.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var postDetailViewModel: PostDetailViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindToViewModel()
    }
    
    // MARK: - Event handlers
    
    private func bindToViewModel() {
        // Creates a subject used for the view model input and triggering initial fetch.
        let fetchObservable = PublishSubject<Void>()

        // Setup view model input and generate output.
        let viewModelInput = PostDetailViewModel.Input(fetch: fetchObservable)
        guard let viewModelOutput = postDetailViewModel?.transform(input: viewModelInput) else { return }

        // Bind UI elements to the view model's output.
        viewModelOutput.postDetail
            .map { $0.author }
            .drive(authorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModelOutput.postDetail
            .map { $0.description }
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        bindErrorEvent(to: viewModelOutput)

        // Trigger initial fetch.
        fetchObservable.onNext(())
        
    }
    
    private func bindErrorEvent(to viewModelOutput: PostDetailViewModel.Output) {
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
    
    private func setupViews() {
        title = "Post"
    }
    
}
