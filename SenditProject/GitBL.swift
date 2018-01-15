//
//  GitBL.swift
//  ChampProject
//
//  Created by Chaithat Sukra on 14/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import CoreData

class GitBL: BaseBL, BLProtocol {
    func requestData(aPage: Int, aSuccess: @escaping ([ItemModel]) -> Void) {
        manager.requestGET("users?since=" + String(aPage)) { (aEvent: ObjectEvent) in
            if aEvent.isSuccessful {
                var items: [ItemModel] = [ItemModel]()
                for o in aEvent.result {
                    
                    let id = o["id"] as! Int
                    let name = o["login"] as! String
                    let url = o["html_url"] as! String
                    let image = o["avatar_url"] as! String
                    
                    let type = o["type"] as! String
                    let admin = o["site_admin"] as! Bool
                    
                    let desc = "Type : " + type + "\n" + "Admin : " + String(admin)
                    
                    let itemModel: ItemModel = ItemModel(id: id, name: name, desc: desc, icon: "", timestamp: 0, url: url, image: image)
                    
                    let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: CoreDataAdapter.sharedInstance.persistentContainer.viewContext) as! Item
                    item.id = o["id"] as! Int16
                    item.name = itemModel.name
                    item.desc = itemModel.desc
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
