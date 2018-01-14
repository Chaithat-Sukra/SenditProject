//
//  MainFactory.swift
//  ChampProject
//
//  Created by Chaithat Sukra on 14/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import Foundation

struct MainFactory {
    public static func getMainBL() -> BLProtocol! {
        if let fileName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            if fileName == "Sendit" {
                return InitBL()
            }
            else if fileName == "Eko" {
                return GitBL()
            }
        }
        return nil
    }
}
