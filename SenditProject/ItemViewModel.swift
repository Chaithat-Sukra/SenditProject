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
    var filteredItems: [ItemModel] = [ItemModel]()
}

extension ItemViewModel {
    public mutating func update(aItems: [ItemModel]) {
        self.items = aItems
        self.filteredItems = aItems
    }
}
