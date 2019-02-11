//
//  PostRepresentation.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

/**
 A post representation model which represents a post parsed from a JSON object.
 */

struct PostRepresentation: Codable {
    
    let identifier: Int
    let userIdentifier: Int
    let title: String
    let body: String
    var comments: [CommentRepresentation]?
    var author: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case userIdentifier = "userId"
        case title
        case body
    }
    
}
