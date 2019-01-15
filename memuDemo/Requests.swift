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

import Foundation
class Requests {
    static var currentAccoutNumber: String = "50179872"
    static var userArray: Array = [String]()
    static var epdArray: Array = [String]()
    static var epdTitles: Array = [String]()
    static var epdData: Array = [String]()
    static var listAccountNumbers: Array = [String]()
    static var authToken: String = ""
    
    

    
    
    static func getUserInfo() {
        let accountNumber = "50179872"

        guard let url = URL(string:"http://5.63.112.4:30000/api/user/card?accountNumber=\(accountNumber)") else {return}
        
        
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
                let user = userData["user"] as? [String:Any]
                print(user ?? "user is Empty")
                self.userArray = [user?["LS"] ,user?["FIO"] , user?["KOL_MAN"] , user?["ADRESS"] , user?["PHONE"] , user?["RAYON"] ,user?["SCH_TYPE"]] as! [String]
                

            }catch {
                print(error)
            }
            
            }.resume()
//        return arrayForReturn
        
    }
    
    //Area with Epd related method and fields
    static func getUserEpd(_ accountNumber: String) {
        let epdTitles = ["Организация", "Назначение" , "К оплате"]
        guard let url = URL(string:"http://5.63.112.4:30000/api/epd?accountNumber=\(accountNumber)") else {return}
        
        
        
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
                self.epdData = [oplInfo![0]["ORG"], oplInfo![0]["NACH_NAME"],oplInfo![0]["K_OPL"]] as! [String]
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
