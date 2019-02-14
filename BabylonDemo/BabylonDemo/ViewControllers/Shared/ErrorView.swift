//
//  ErrorView.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 14.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.appFont(with: 17)
        label.textColor = UIColor.cream
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var height: CGFloat = 50.0
    private var width: CGFloat = UIScreen.main.bounds.width - 20
    private var padding: CGFloat = 20
    
    init(frame: CGRect = CGRect.zero, message: String) {
        super.init(frame: frame)
        textLabel.text = message
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in viewController: UIViewController) {
        let y = UIScreen.main.bounds.height - height
        let x = padding / 2
        frame = CGRect(x: x, y: y, width: width, height: height)
        alpha = 0.0
        
        viewController.view.addSubview(self)
        moveIn()
    }
    
    private func moveIn() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn,  animations: {
            self.alpha = 1.0
            self.center.y -= 4 * self.height
        }) { _ in
            self.moveOut()
        }
    }
    
    private func moveOut() {
        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseOut, animations: {
            self.alpha = 0.0
            self.center.y += 4 * self.height
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    private func setupViews() {
        backgroundColor = UIColor.sunRed
        addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * padding).isActive = true
    }
    
}
