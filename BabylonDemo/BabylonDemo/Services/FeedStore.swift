//
//  CoreDataStack.swift
//  BabylonDemo
//
//  Created by De MicheliStefano on 11.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

/**
 The protocol for fetching data for the post feed from the local persistence store.
 */

protocol FeedPersistenceStoreProtocol {
    func save(context: NSManagedObjectContext)
    func loadPosts() -> Observable<[PostRepresentation]>
    func loadComments() -> Observable<[CommentRepresentation]>
    func loadUsers() -> Observable<[UserRepresentation]>
}

/**
 The persistence store service for fetching post feed data from the local persistence store.
 */

class FeedStore {
    
    enum Entities {
        case post, comment, user
    }
    
    static let shared = FeedStore()
    
    func save(context: NSManagedObjectContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                NSLog("Error while saving to persistent store: \(saveError)")
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Feed")
        container.loadPersistentStores  { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}


