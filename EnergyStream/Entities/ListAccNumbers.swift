//
//  listAccoountNumbers.swift
//  EnergyStream
//
//  Created by Timur on 3/12/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation

struct ListAccNumbers {
    var accountNumber: String
    var createdDate: Double
    var FIO: String
    var PHONE: String
    
    init(_ dictionary: [String:Any]) {
        self.accountNumber = dictionary["accountNumber"] as? String ?? ""
        self.createdDate = dictionary["createdDate"] as? Double ?? 0
        self.FIO = dictionary["FIO"] as? String ?? ""
        self.PHONE = dictionary["PHONE"] as? String ?? ""
    }
}
