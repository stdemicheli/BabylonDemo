//
//  UserRepresentation.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation

/**
 A user representation model which represents a user parsed from a JSON object.
 */

struct UserRepresentation: Codable {
    
    let identifier: Int
    let name: String
    let username: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case username
        case email
    }
    
}
