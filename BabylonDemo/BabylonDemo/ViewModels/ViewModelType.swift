//
//  ViewModelType.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 12.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

/**
 A protocol for view models which defines the handling of inputs and outputs.
 */

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
