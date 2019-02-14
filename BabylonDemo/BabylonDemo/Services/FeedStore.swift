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
    var container: NSPersistentContainer { get }
    var mainContext: NSManagedObjectContext { get }
    func save(context: NSManagedObjectContext) throws
    func load<Resource: NSManagedObject>(with identifier: Int, context: NSManagedObjectContext) -> Resource?
    func load<Resource: NSManagedObject>(recent fetchLimit: Int, in context: NSManagedObjectContext) -> [Resource]
}

/**
 The persistence store service for fetching post feed data from the local persistence store.
 */

class FeedStore: FeedPersistenceStoreProtocol {
    
    enum Entities {
        case post, comment, user
    }
    
    // MARK: - Properties
    
    static let shared = FeedStore()
    
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
    
    // MARK: - Public methods
    
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
    
    func load<Resource: NSManagedObject>(with identifier: Int, context: NSManagedObjectContext) -> Resource? {
        var resource: Resource? = nil
        
        let fetchRequest: NSFetchRequest<Resource> = Resource.fetchRequest() as! NSFetchRequest<Resource>
        let predicate = NSPredicate(format: "identifier == %d", identifier)
        fetchRequest.predicate = predicate
        
        context.performAndWait {
            do {
                resource = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error loading from persistent store: \(error)")
            }
        }
        
        return resource
    }
    
    func load<Resource: NSManagedObject>(recent fetchLimit: Int, in context: NSManagedObjectContext) -> [Resource] {
        var resource = [Resource]()
        
        let fetchRequest: NSFetchRequest<Resource> = Resource.fetchRequest() as! NSFetchRequest<Resource>
        let idSortDescriptor = NSSortDescriptor(key: "identifier", ascending: false)
        fetchRequest.sortDescriptors = [idSortDescriptor]
        fetchRequest.fetchLimit = fetchLimit
        
        context.performAndWait {
            do {
                resource = try context.fetch(fetchRequest)
            } catch {
                NSLog("Error loading from persistent store: \(error)")
            }
        }
        
        return resource
    }
    
}


