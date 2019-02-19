//
//  Requests.swift
//  memuDemo
//
//  Created by Timur on 1/10/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//
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

struct AccNumSheet {
    var dataName: String
    var dataValue: String
    
    
    init(_ dictionary: [String:Any]) {
        self.dataName = dictionary["DATA_NAME"] as? String ?? ""
        self.dataValue = dictionary["DATA_VAL"] as? String ?? ""
        
    }
}


struct UserCard {
    var accountNumber: String
//    var firstName: String
//    var lastName: String
//    var middleName: String
    var numberOfPeople: String
    var address: String
    var phoneNumber: String
    var SCH_TYPE: String
    var fio: String
    var area: String
    
    init(_ userCard: [String:Any]) {
        self.accountNumber = userCard["LS"] as? String ?? "Не указано"
        self.fio = userCard["FIO"] as? String ?? ""
//        self.firstName = ""
//        self.lastName = ""
//        self.middleName = "Не указано"
        self.numberOfPeople = userCard["KOL_MAN"] as? String ?? ""
        self.address = userCard["ADRESS"] as? String ?? "Не указано"
        self.phoneNumber = userCard["PHONE"] as? String ?? "Не указано"
        self.SCH_TYPE = userCard["SCH_TYPE"] as? String ?? "Не указано"
        self.area = userCard["RAYON"] as? String ?? "Не указано"
    }
    init() {
        self.accountNumber = ""
        self.fio = ""
        self.numberOfPeople = ""
        self.address = ""
        self.phoneNumber = ""
        self.SCH_TYPE = ""
        self.area = ""
    }
    func getPropertyCount() -> Int{
        return 6
    }
}

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
        self.ticketTitle = ticketDic["title"] as! String
        self.ticketMsg = ticketDic["msg"] as! String
        self.ticketNumber = String(ticketDic["number"] as! Int)
        
    }
}

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

import Foundation
import PDFKit
import Alamofire

class Requests {
    static var currentAccoutNumber: String = ""
    static var authToken: String = ""
    static var currentUser = UserCard()

    
    
    //Area with Epd related method and fields

    
   
   
    
    

}
