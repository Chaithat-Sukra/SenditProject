//
//  Item+CoreDataProperties.swift
//  SenditProject
//
//  Created by Chaithat Sukra on 10/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var desc: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: Int16
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Int64
    @NSManaged public var url: String?

}
