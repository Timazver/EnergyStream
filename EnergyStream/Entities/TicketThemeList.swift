//
//  TicketThemeList.swift
//  EnergyStream
//
//  Created by Timur on 3/16/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation

struct TicketThemeList {
    let id: Int
    let name: String
    
    init(dic:[String:Any]) {
        self.id = dic["id"] as? Int ?? 0
        self.name = dic["name"] as? String ?? ""
    }
    
    init() {
        self.id = 0
        self.name = ""
    }
}
