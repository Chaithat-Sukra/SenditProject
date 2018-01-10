//
//  InitBL.swift
//  SenditProject
//
//  Created by Chaithat Sukra on 10/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import Foundation
import CoreData

class InitBL: NSObject {
    let manager: HTTPSessionManager = HTTPSessionManager()
    
    func requestData(aSuccess: @escaping ([ItemModel]) -> Void) {
        manager.requestGET("api/items/list.json") { (aEvent: ObjectEvent) in
            var items: [ItemModel] = [ItemModel]()
            for o in aEvent.result {
                let itemModel: ItemModel = ItemModel(aData: o)
                
                let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: CoreDataAdapter.sharedInstance.persistentContainer.viewContext) as! Item
                item.id = itemModel.id
                item.name = itemModel.name
                item.desc = itemModel.desc
                item.icon = itemModel.icon
                item.timestamp = itemModel.timestamp
                item.url = itemModel.url
                item.image = itemModel.image
                
                items.append(itemModel)
                if items.count == 20 {
                    break
                }
            }
            
            CoreDataAdapter.sharedInstance.saveContext { (aCompletion) in
                if aCompletion == true {
                    aSuccess(items)
                }
            }
        }
    }
}
