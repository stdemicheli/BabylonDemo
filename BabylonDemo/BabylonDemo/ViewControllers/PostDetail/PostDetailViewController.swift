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
    
    private func bindToViewModel() {
        // Creates a subject used for the view model input and triggering initial fetch.
        let fetchObservable = PublishSubject<Void>()

        // Setup view model input and generate output.
        let input = PostDetailViewModel.Input(fetch: fetchObservable)
        let output = postDetailViewModel?.transform(input: input)

        // Bind UI elements to the view model's output.
        output?.postDetail
            .map { $0.author }
            .drive(authorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output?.postDetail
            .map { $0.description }
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        // Trigger initial fetch.
        fetchObservable.onNext(())
        
    }
    
    private func setupViews() {
        title = "Post"
    }
    
}
