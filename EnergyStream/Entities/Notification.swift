//
//  Notification.swift
//  EnergyStream
//
//  Created by Timur on 3/12/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation

struct Notification {
    var title: String
    var date: String
    
    init(_ dic:[String:Any]) {
        let timeInUnixFormat = dic["createdDate"] as? Double ?? 0
        let newTime = Date(timeIntervalSince1970: TimeInterval(timeInUnixFormat/1000))
        
        self.title = dic["title"] as? String ?? ""
        self.date = newTime.toString(dateFormat: "dd-MM-YYYY")
    }
    
    
}
