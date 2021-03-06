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
    
    /// Error types for indicating the type of error that occured during the feed cycle.
    enum Types: Error {
        case requestFailed, decodingFailed, noConnection, valueNotFound, none
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
        case .valueNotFound:
            return "Could not find post."
        case .none:
            return ""
        }
    }
    
}
