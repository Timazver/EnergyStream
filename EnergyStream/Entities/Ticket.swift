//
//  Ticket.swift
//  EnergyStream
//
//  Created by Timur on 3/12/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
struct Ticket {
    var ticketId: String
    var date: String
    var ticketTitle: String
    var ticketMsg: String
    var ticketNumber: String
    
    init(_ ticketDic: [String: Any]) {
        let timeInUnixFormat = ticketDic["createdDate"] as! Double
        let newTime = Date(timeIntervalSince1970: TimeInterval(timeInUnixFormat/1000))
        
        self.ticketId = ticketDic["_id"] as! String
        self.date = newTime.toString(dateFormat: "dd-MM-YYYY")
        self.ticketTitle = ticketDic["title"] as? String ??  ""
        self.ticketMsg = ticketDic["msg"] as! String
        self.ticketNumber = String(ticketDic["number"] as! Int)
        
    }
}
