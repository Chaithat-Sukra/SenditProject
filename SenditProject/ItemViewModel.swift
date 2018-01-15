//
//  ItemViewModel.swift
//  SenditProject
//
//  Created by Chaithat Sukra on 10/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import UIKit

struct ItemViewModel {
    var items: [ItemModel] = [ItemModel]()
    var favourites: [ItemModel] = [ItemModel]()
    var filteredItems: [ItemModel] = [ItemModel]()
}

extension ItemViewModel {
    public mutating func update(aItems: [ItemModel]) {
        self.items.append(contentsOf: aItems)
        self.filteredItems = self.items
    }
    
    public mutating func updateItemAtIndex(aIndex: Int, aItem: ItemModel) {
        var newItem: ItemModel = aItem
        newItem.isFavourited = !newItem.isFavourited
        self.items[aIndex] = newItem
        self.filteredItems = self.items
    }
    
    public mutating func updateFavourite(aItems: [ItemModel]) {
        self.favourites = aItems
        self.filteredItems = self.favourites
    }
    
    public mutating func usingFavourite() {
        self.filteredItems = self.favourites
    }
}
