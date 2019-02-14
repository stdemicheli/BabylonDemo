//
//  FeedError.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 14.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

/**
 An error model for handling feed errors.
 */

struct FeedError {
    
    /// An error type for handling errors that occur during the Feed cycle.
    enum Types: Error {
        case requestFailed, decodingFailed, noConnection, none
    }
    
    /// A type indicating the feed error type.
    var type: FeedError.Types
    
    /// An error message to be displayed to the user.
    var message: String {
        switch self.type {
        case .requestFailed:
            return "Error while fetching feed. Please try again."
        case .decodingFailed:
            return "Error while fetching feed. Please try again."
        case .noConnection:
            return "No internet connection."
        case .none:
            return ""
        }
    }
    
}
