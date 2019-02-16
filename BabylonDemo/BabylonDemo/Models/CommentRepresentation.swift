//
//  CommentRepresentation.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

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

/**
 Convenience initializers for turning CommentRepresentations into Comment models.
 */

extension Comment {
    
    convenience init(identifier: Int16, postIdentifier: Int16, name: String, body: String, email: String, context: NSManagedObjectContext = FeedStore.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.postIdentifier = postIdentifier
        self.name = name
        self.body = body
        self.email = email
    }
    
    /// An convenience initializer that initializes a Comment model from a parsed JSON object.
    convenience init(commentRepresentation: CommentRepresentation, context: NSManagedObjectContext = FeedStore.shared.mainContext) {
        self.init(identifier: Int16(commentRepresentation.identifier),
                  postIdentifier: Int16(commentRepresentation.postIdentifier),
                  name: commentRepresentation.name,
                  body: commentRepresentation.body,
                  email: commentRepresentation.email,
                  context: context)
    }
    
    /// Converts CommentRepresentations into a list of Comment models and persists them locally.
    static func convert(from representations: [CommentRepresentation], in context: NSManagedObjectContext = FeedStore.shared.mainContext) -> [Comment] {
        let comments = representations.map { Comment(commentRepresentation: $0, context: context) }
        
        do {
            try FeedStore.shared.save(context: context)
        } catch {
            NSLog("Error saving comments to local store: \(error)")
        }
        
        return comments
    }
    
}

