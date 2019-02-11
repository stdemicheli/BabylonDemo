//
//  CommentRepresentation.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

/**
 A comment representation model which represents a comment parsed from a JSON object.
 */

struct CommentRepresentation: Codable {
    
    let identifier: Int
    let postIdentifier: Int
    let name: String
    let email: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case postIdentifier = "postId"
        case name
        case email
        case body
    }
    
}
