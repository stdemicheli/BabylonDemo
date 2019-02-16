//
//  Colors.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 13.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit

/**
 An extension for adding custom colors.
 */

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let aztec = UIColor.rgb(red: 38, green: 39, blue: 41)
    static let cream = UIColor.rgb(red: 232, green: 234, blue: 221)
    static let lightCream = UIColor.rgb(red: 229, green: 231, blue: 218)
    static let sunOrange = UIColor.rgb(red: 255, green: 111, blue: 56)
    static let sunRed = UIColor.rgb(red: 226, green: 17, blue: 58)
    
}
