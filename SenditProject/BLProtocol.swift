//
//  BLProtocol.swift
//  ChampProject
//
//  Created by Chaithat Sukra on 14/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import Foundation

protocol BLProtocol {
    func requestData(aSuccess: @escaping ([ItemModel]) -> Void)
}
