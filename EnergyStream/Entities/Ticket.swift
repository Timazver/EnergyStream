//
//  Ticket.swift
//  EnergyStream
//
//  Created by Timur on 3/12/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
import UIKit

struct Ticket {
    var ticketId: String
    var date: String
    var ticketTitle: String
    var ticketMsg: String
    var ticketNumber: String
    var imagesUrlArray:[String]
    
    init(_ ticketDic: [String: Any]) {
        var array = [String]()
        let timeInUnixFormat = ticketDic["createdDate"] as! Double
        let newTime = Date(timeIntervalSince1970: TimeInterval(timeInUnixFormat/1000))
        
        self.ticketId = ticketDic["_id"] as! String
        self.date = newTime.toString(dateFormat: "dd-MM-YYYY")
        
        let title = ticketDic["title"] as? [String:Any]
        self.ticketTitle = title!["name"] as? String ??  ""
        
        self.ticketMsg = ticketDic["msg"] as! String
        self.ticketNumber = String(ticketDic["number"] as! Int)
        
        let files = ticketDic["files"] as? [[String:Any]]
        for file in files! {
            array.append(file["url"] as! String)
        }
        self.imagesUrlArray = array
    }
    
    init() {
        self.ticketId = ""
        self.date = ""
        self.ticketTitle = ""
        self.ticketMsg = ""
        self.ticketNumber = ""
        self.imagesUrlArray = [String]()
}
}
