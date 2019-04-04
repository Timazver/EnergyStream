//
//  AccNumSheet.swift
//  EnergyStream
//
//  Created by Timur on 3/12/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
struct AccNumSheet {
    var dataName: String
    var dataValue: String
    
    
    init(_ dictionary: [String:Any]) {
        self.dataName = dictionary["DATA_NAME"] as? String ?? ""
        self.dataValue = dictionary["DATA_VAL"] as? String ?? ""
        
    }
}
