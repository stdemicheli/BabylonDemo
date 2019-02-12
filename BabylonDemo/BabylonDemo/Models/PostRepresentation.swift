//
//  PostRepresentation.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

/**
 A post representation model which represents a post parsed from a JSON object.
 */

struct PostRepresentation: Codable {
    
    let identifier: Int
    let userIdentifier: Int
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case userIdentifier = "userId"
        case title
        case body
    }
    
}

/**
 Convenience initializers for turning PostRepresentations into Post models.
 */

extension Post {
    
    convenience init(identifier: Int16, userIdentifier: Int16, title: String, body: String, author: String? = nil, context: NSManagedObjectContext = FeedStore.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.userIdentifier = userIdentifier
        self.title = title
        self.body = body
        self.author = author
    }
    
    /// An convenience initializer that initializes a Post model from a parsed JSON object.
    convenience init(postRepresentation: PostRepresentation, context: NSManagedObjectContext = FeedStore.shared.mainContext) {
        self.init(identifier: Int16(postRepresentation.identifier),
                  userIdentifier: Int16(postRepresentation.userIdentifier),
                  title: postRepresentation.title,
                  body: postRepresentation.body,
                  context: context)
    }
    
    /// Converts PostRepresentations into a list of Post models.
    static func convert(from representations: [PostRepresentation]) -> [Post] {
        return representations.map { Post(postRepresentation: $0) }
    }
    
}
