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
    var organization: String = ""
    var destination: String = ""
    var sumForPayment: String = ""
    
    init(_ epdArray: [String:Any]) {
        self.organization = epdArray["ORG"] as? String ?? "Не указано"
        self.destination = epdArray["NACH_NAME"] as? String ?? "Не указано"
        self.sumForPayment = epdArray["K_OPL"] as? String ?? "Не указано"
    }
}

import Foundation
import PDFKit
import Alamofire

class Requests {
    static var currentAccoutNumber: String = ""
//    static var userArray: Array = [String]()
    static var userModel: Array = [UserCard]()
//    static var epdArray: Array = [String]()
    static var epdTitles: Array = [String]()
    static var epdModel: Array = [epdData]()
//    static var listAccountNumbers: Array = [ListAccNumbers]()
    static var authToken: String = ""
    static var totalSumForPay: String = ""
    static var pdfFileName: String = ""
//    static var ticketListArray: Array = [Ticket]() 
//    static var bankArray: Array = [Bank]()
    
    static func getUserInfo(userAccNumber: String) {
        

        guard let url = URL(string:"\(Constants.URLForApi ?? "")/api/user/card?accountNumber=\(userAccNumber)") else {return}
        
        
        var requestForUserInfo = URLRequest(url:url )
        requestForUserInfo.httpMethod = "GET"
        requestForUserInfo.addValue("Bearer \(authToken) ", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: requestForUserInfo) {
            (data,response,error) in
            
            if let response = response {
                print(response)
            }
            
            guard let data = data else {return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                guard let userData = json as? [String:Any] else {return}
                
                guard let user = userData["user"] as? [String:Any] else {
                    print("User is empty")
                    return}
                
                if userModel.isEmpty {
                userModel.append(UserCard(user))
//                Requests.divideFio(user["FIO"] as! String)
                
               
                }
                else {
                    userModel.removeAll()
                }
//                self.userArray = [user?["LS"] ,user?["FIO"] , user?["KOL_MAN"] , user?["ADRESS"] , user?["PHONE"] , user?["RAYON"] ,user?["SCH_TYPE"]] as! [String]
                print(userModel)

            }catch {
                print(error)
            }
            
            }.resume()
//        return arrayForReturn
        
    }
    
    
    //Area with Epd related method and fields
    static func getUserEpd(_ accountNumber: String) {
        let epdTitles = ["Организация", "Назначение" , "К оплате"]
        guard let url = URL(string:"\(Constants.URLForApi ?? "")/api/epd?accountNumber=\(currentAccoutNumber)") else {return}
        
        
        
        var requestForUserInfo = URLRequest(url:url )
        
        requestForUserInfo.httpMethod = "GET"
        requestForUserInfo.addValue("Bearer \(authToken) ", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        session.dataTask(with: requestForUserInfo) {
            (data,response,error) in
            
            if let response = response {
//                print(response)
            }
            
            guard let data = data else {return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
                guard let jsonData = json as? [String:AnyObject] else {return}
                let epdDataArray = jsonData["epdData"] as? [String:AnyObject]
                guard let oplInfo = epdDataArray?["opl_info"] as? [[String:Any]] else {print("Текущих начислений нет")
                    return
                }
//
                
//                    print(oplInfo)
                    if epdModel.isEmpty {
                        for dic in oplInfo {
                        epdModel.append(epdData(dic))
                            print(dic)
                        }
                    }
//                    else {
//                        Requests.epdModel.removeAll()
//                        print(Requests.epdModel)
//                    }
                
                
            }catch {
                print(error)
            }
            
            }.resume()
        print(epdModel.count)
    }
    
   
   
    
    

}
