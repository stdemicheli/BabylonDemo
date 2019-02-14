//
//  Appearance.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 13.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit

struct Appearance {
    static func appFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
    
    static func setupNavBar() {
        UINavigationBar.appearance().barTintColor = UIColor.aztec
        UINavigationBar.appearance().tintColor = UIColor.cream
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: Appearance.appFont(with: 20)]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: Appearance.appFont(with: 30)]
        UINavigationBar.appearance().isTranslucent = false
    }
}
