//
//  Colors.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 13.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let aztec = UIColor.rgb(red: 38, green: 39, blue: 41)
    static let cream = UIColor.rgb(red: 232, green: 234, blue: 221)
    static let lightCream = UIColor.rgb(red: 229, green: 231, blue: 218)
    
    static let darkColor = UIColor.rgb(red: 0, green: 52, blue: 89)
    static let darkBlue = UIColor.rgb(red: 0, green: 52, blue: 89)
    static let lightPurple = UIColor.rgb(red: 59, green: 206, blue: 172)
    static let correctGreen = UIColor.rgb(red: 76, green: 185, blue: 68)
    static let incorrectRed = UIColor.rgb(red: 254, green: 95, blue: 85)
    static let sunOrange = UIColor.rgb(red: 255, green: 111, blue: 56)
    static let sunRed = UIColor.rgb(red: 226, green: 17, blue: 58)
    static let mountainBlue = UIColor.rgb(red: 47, green: 157, blue: 254)
    static let mountainDark = UIColor.rgb(red: 36, green: 36, blue: 36)
    static let nightSkyBlue = UIColor.rgb(red: 5, green: 102, blue: 141)
    static let nightSkyDark = UIColor.rgb(red: 11, green: 19, blue: 43)
    static let morningSkyBlue = UIColor.rgb(red: 105, green: 221, blue: 255)
    static let brightSky = UIColor.rgb(red: 157, green: 228, blue: 242)
}
