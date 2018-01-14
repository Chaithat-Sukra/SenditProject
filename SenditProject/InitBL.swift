//
//  InitBL.swift
//  SenditProject
//
//  Created by Chaithat Sukra on 10/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import CoreData

class InitBL: BaseBL, BLProtocol {
    func requestData(aSuccess: @escaping ([ItemModel]) -> Void) {
        manager.requestGET("api/items/list.json") { (aEvent: ObjectEvent) in
            if aEvent.isSuccessful {
                var items: [ItemModel] = [ItemModel]()
                for o in aEvent.result {
                    
                    let id = o["id"] as! Int16
                    let name = o["name"] as! String
                    let desc = o["description"] as! String
                    let icon = o["icon"] as! String
                    let timestamp = o["timestamp"] as! Int64
                    let url = o["url"] as! String
                    let image = o["image"] as! String
                    
                    let itemModel: ItemModel = ItemModel(id: id, name: name, desc: desc, icon: icon, timestamp: timestamp, url: url, image: image)
                    
                    let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: CoreDataAdapter.sharedInstance.persistentContainer.viewContext) as! Item
                    item.id = itemModel.id
                    item.name = itemModel.name
                    item.desc = itemModel.desc
                    item.icon = itemModel.icon
                    item.timestamp = itemModel.timestamp
                    item.url = itemModel.url
                    item.image = itemModel.image
                    
                    items.append(itemModel)
                }
                
                CoreDataAdapter.sharedInstance.saveContext { (aCompletion) in
                    if aCompletion == true {
                        aSuccess(items)
                    }
                }   
            }
            else {
                aSuccess([])
            }
        }
    }
}
