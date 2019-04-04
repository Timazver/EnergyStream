//
//  epdData.swift
//  EnergyStream
//
//  Created by Timur on 3/12/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
struct epdData {
    var organization: String
    var destination: String
    var sumForPayment: String
    var sumByInt: Int
    
    init(_ epdArray: [String:Any]) {
        self.organization = epdArray["ORG"] as? String ?? "Не указано"
        self.destination = epdArray["NACH_NAME"] as? String ?? "Не указано"
        self.sumByInt = Int(epdArray["K_OPL"] as! String)!
        print(sumByInt)
        self.sumForPayment = sumByInt.formattedWithSeparator
    }
}
