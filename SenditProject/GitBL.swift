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
                    
                    do {
                        let id = o["id"] as! Int
                        let name = o["login"] as! String
                        let url = o["html_url"] as! String
                        let image = o["avatar_url"] as! String
                        
                        let type = o["type"] as! String
                        let admin = o["site_admin"] as! Bool
                        
                        let desc = "Type : " + type + "\n" + "Admin : " + String(admin)
                        
                        var isFav: Bool = false
                        
                        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
                        fetch.predicate = NSPredicate(format: "id == \(id)")
                        let results = try CoreDataAdapter.sharedInstance.persistentContainer.viewContext.fetch(fetch) as! [Item]
                        if let first = results.first {
                            isFav = true
                        }
                        let itemModel: ItemModel = ItemModel(id: id, name: name, desc: desc, icon: "", timestamp: 0, url: url, image: image, isFavourited: isFav)
                        items.append(itemModel)
                    }
                    catch {
                        print("Something Happen")
                    }
                }
                aSuccess(items)
            }
            else {
                aSuccess([])
            }
        }
    }
}
