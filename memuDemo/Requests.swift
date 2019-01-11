//
//  Requests.swift
//  memuDemo
//
//  Created by Timur on 1/10/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
class Requests {
    static var currentAccoutNumber: String = ""
    static var userArray: Array = [String]()
    static var epdArray: Array = [String]()
    static var epdTitles: Array = [String]()
    static var epdData: Array = [String]()
    
    static func getUserInfo() {
        let accountNumber = "50179872"

        guard let url = URL(string:"http://192.168.1.161:3000/api/user/card?accountNumber=\(accountNumber)") else {return}
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVjMzczNDBjNzg0OTI4NGZiMTA3NTY4MCIsImlhdCI6MTU0NzE3ODU4NCwiZXhwIjoxNTQ3MjY0OTg0fQ.aQ1CACw2_8Ga0J55ebXT4BbaiEKEP8yPpJvjAVa-RfI"
        
        var requestForUserInfo = URLRequest(url:url )
        requestForUserInfo.httpMethod = "GET"
        requestForUserInfo.addValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
        
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
                print(user)
                self.userArray = [user?["LS"] ,user?["FIO"] , user?["KOL_MAN"] , user?["ADRESS"] , user?["PHONE"] , user?["RAYON"] ,user?["SCH_TYPE"]] as! [String]
                

            }catch {
                print(error)
            }
            
            }.resume()
//        return arrayForReturn
        
    }
    
    //Area with Epd related method and fields
    static func getUserEpd() {
        let accountNumber = "50179872"
        let epdTitles = ["Организация", "Назначение" , "К оплате"]
        guard let url = URL(string:"http://192.168.1.161:3000/api/user/epd?accountNumber=\(accountNumber)") else {return}
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVjMzczNDBjNzg0OTI4NGZiMTA3NTY4MCIsImlhdCI6MTU0NzE3ODU4NCwiZXhwIjoxNTQ3MjY0OTg0fQ.aQ1CACw2_8Ga0J55ebXT4BbaiEKEP8yPpJvjAVa-RfI"
        
        var requestForUserInfo = URLRequest(url:url )
        
        requestForUserInfo.httpMethod = "GET"
        requestForUserInfo.addValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
        
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
        guard let url = URL(string:"http://192.168.1.161:3000/api/user/profile") else {return}
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVjMzczNDBjNzg0OTI4NGZiMTA3NTY4MCIsImlhdCI6MTU0NzE3ODU4NCwiZXhwIjoxNTQ3MjY0OTg0fQ.aQ1CACw2_8Ga0J55ebXT4BbaiEKEP8yPpJvjAVa-RfI"
        
        var requestForUserInfo = URLRequest(url:url )
        
        requestForUserInfo.httpMethod = "GET"
        requestForUserInfo.addValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
        
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
                print(user)
            }catch {
                print(error)
            }
            
            }.resume()
     
    }
}
