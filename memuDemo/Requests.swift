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
struct CellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

struct UserCard {
    var accountNumber: String
    var firstName: String
    var lastName: String
    var middleName: String
    var numberOfPeople: String
    var address: String
    var phoneNumber: String
    var SCH_TYPE: String
    var fio: String
    var area: String
    
    init(_ userCard: [String:Any]) {
        self.accountNumber = userCard["LS"] as? String ?? "Не указано"
        self.fio = userCard["FIO"] as? String ?? ""
        self.firstName = ""
        self.lastName = ""
        self.middleName = "Не указано"
//        self.firstName = String(fioArray[1] as? Substring ?? "Не указано")
//        self.lastName = String(fioArray[0] as? Substring ?? "Не указано")
//        self.middleName = String(fioArray[2].isEmpty ? fioArray[2] as! Substring : "Не указано")
        self.numberOfPeople = userCard["KOL_MAN"] as? String ?? ""
        self.address = userCard["ADRESS"] as? String ?? "Не указано"
        self.phoneNumber = userCard["PHONE"] as? String ?? "Не указано"
        self.SCH_TYPE = userCard["SCH_TYPE"] as? String ?? "Не указано"
        self.area = userCard["RAYON"] as! String ?? "Не указано"
    }
}

import Foundation
class Requests {
    static var currentAccoutNumber: String = ""
//    static var userArray: Array = [String]()
    static var userModel: Array = [UserCard]()
    static var epdArray: Array = [String]()
    static var epdTitles: Array = [String]()
    static var epdData: Array = [String]()
    static var listAccountNumbers: Array = [String]()
    static var authToken: String = ""
    
    
    static func divideFio(_ fio: String) {
        let fioArray = fio.split(separator: " ")
        Requests.userModel[0].firstName = String(fioArray[1])
        Requests.userModel[0].lastName = String(fioArray[0])
        Requests.userModel[0].middleName = "Не указано"
    }
    
    
    static func getUserInfo() {
        

        guard let url = URL(string:"http://5.63.112.4:30000/api/user/card?accountNumber=\(self.currentAccoutNumber)") else {return}
        
        
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
                Requests.divideFio(user["FIO"] as! String)
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
        guard let url = URL(string:"http://5.63.112.4:30000/api/epd?accountNumber=\(currentAccoutNumber)") else {return}
        
        
        
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
                guard let jsonData = json as? [String:AnyObject] else {return}
                let epdDataArray = jsonData["epdData"] as? [String:AnyObject]
                let oplInfo = epdDataArray?["opl_info"] as? [AnyObject]
                if oplInfo == nil {
                    print("Текущий начислений нет")
                }
                else {
                    print(oplInfo)
                self.epdData = [oplInfo![0]["ORG"], oplInfo![0]["NACH_NAME"],oplInfo![0]["K_OPL"]] as! [String]
                }
            }catch {
                print(error)
            }
            
            }.resume()
        self.epdTitles = epdTitles
    }
    
    
    
    //Get user object with list of Account Numbers
    static func getListAccountNumbers() {
        guard let url = URL(string:"http://5.63.112.4:30000/api/user/profile") else {return}
        
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
                guard let userData = json as? [String:Any] else {return}
                let user = userData["user"] as? [String:Any]
                self.currentAccoutNumber = user?["accountNumber"] as! String
                print(currentAccoutNumber)
                let accountNumbersArray = user?["listAccountNumbers"] as! [[String:Any]]
                
                //Try to parse array of ListAccNumbers into array of Structure
                var model = [ListAccNumbers]()
                for list in accountNumbersArray {
                    model.append(ListAccNumbers(list))
                }
                
                //Check if listAccountNumbers is empty, if not need to clear it
                if !Requests.listAccountNumbers.isEmpty {
                    Requests.listAccountNumbers.removeAll()
                }
            
                
                for accountNumber in model {
                    Requests.listAccountNumbers.append(accountNumber.accountNumber)
                    print(accountNumber)
                    
                }
                
                
                
                
                print("Loop finished successfully")
                print(Requests.listAccountNumbers.count)
            }catch {
                print(error)
            }
            
            }.resume()
     
    }
}
