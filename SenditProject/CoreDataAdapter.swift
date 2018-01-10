//
//  CoreDataAdapter.swift
//  COSC2471
//
//  Created by Chaithat Sukra on 29/9/17.
//  Copyright © 2017 Chaithat Sukra. All rights reserved.
//

import Foundation
import CoreData

class CoreDataAdapter {
    
    var name: String!
    
    class var sharedInstance: CoreDataAdapter {
        struct Singleton {
            static let instance = CoreDataAdapter()
        }
        return Singleton.instance
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SenditCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext(aCompletion: @escaping (_ aResult: Bool) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                aCompletion(false)
            }
            aCompletion(true)
        }
    }
    
    // MARK: - Core Data Deleting support
    func deleteObject(aManageObject: NSManagedObject, aCompletion: (_ aResult: Bool) -> Void) {
        let context = persistentContainer.viewContext
        context.delete(aManageObject)
        
        do {
            try context.save()
        }
        catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            aCompletion(false)
        }
        aCompletion(true)
    }
}
