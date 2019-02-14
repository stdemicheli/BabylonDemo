//
//  UserRepresentation.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

/**
 A user representation model which represents a user parsed from a JSON object.
 */

struct UserRepresentation: Codable, Representation {
    
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

/**
 Convenience initializers for turning UserRepresentations into User models.
 */

extension User {
    
    convenience init(identifier: Int16, name: String, username: String, email: String, context: NSManagedObjectContext = FeedStore.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.username = username
        self.email = email
    }
    
    /// An convenience initializer that initializes a User model from a parsed JSON object.
    convenience init(userRepresentation: UserRepresentation, context: NSManagedObjectContext = FeedStore.shared.mainContext) {
        self.init(identifier: Int16(userRepresentation.identifier),
                  name: userRepresentation.name,
                  username: userRepresentation.username,
                  email: userRepresentation.email,
                  context: context)
    }
    
    /// Converts UserRepresentations into a list of User models.
    static func convert(from representations: [UserRepresentation]) -> [User] {
        return representations.map { User(userRepresentation: $0) }
    }
    
}
