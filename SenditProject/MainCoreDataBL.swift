//
//  MainCoreDataBL.swift
//  ChampProject
//
//  Created by Chaithat Sukra on 16/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import Foundation
import CoreData

struct MainCoreDataBL {
    public func queryFavourites() -> [ItemModel] {
        var itemModels: [ItemModel] = [ItemModel]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do {
            let items: [Item] = try CoreDataAdapter.sharedInstance.persistentContainer.viewContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Item]
            
            for o in items {
                
                let itemModel: ItemModel = ItemModel(id: Int(o.id), name: o.name, desc: o.desc, icon: "", timestamp: 0, url: o.url, image: o.image, isFavourited: true)
                itemModels.append(itemModel)
            }
            return itemModels
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    public func addFavourited(aItemModel: ItemModel) -> Void {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Item", into: CoreDataAdapter.sharedInstance.persistentContainer.viewContext) as! Item
        newEntity.name = aItemModel.name
        newEntity.desc = aItemModel.desc
        newEntity.url = aItemModel.url
        newEntity.image = aItemModel.image
        newEntity.id = Int16(aItemModel.id)
        
        CoreDataAdapter.sharedInstance.saveContext { (aCompletion) in
            if (aCompletion) {
                print("Saved")
            }
        }
    }
    
    public func removeFavourited(aItemModel: ItemModel) -> Void {
        do {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            let id: Int = aItemModel.id!
            fetch.predicate = NSPredicate(format: "id == \(id)")
            let results = try CoreDataAdapter.sharedInstance.persistentContainer.viewContext.fetch(fetch) as! [Item]
            if let item = results.first {
                CoreDataAdapter.sharedInstance.deleteObject(aManageObject: item, aCompletion: { (aCompletion) in
                    print("Deleted")
                })
            }
        }
        catch {
            print("Core Data Error")
        }
    }
}
