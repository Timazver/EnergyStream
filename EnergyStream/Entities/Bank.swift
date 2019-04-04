//
//  Bank.swift
//  EnergyStream
//
//  Created by Timur on 3/12/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
struct Bank {
    var name: String
    var link: String
    var imgUrl: String
    
    init(_ dic: [String:Any]) {
        self.name = dic["name"] as! String
        self.link = dic["link"] as! String
        self.imgUrl = "\(Constants.URLForApi  ?? "")\(dic["imgUrl"] ?? "")"
    }
}
