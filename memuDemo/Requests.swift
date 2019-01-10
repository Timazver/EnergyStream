//
//  Requests.swift
//  memuDemo
//
//  Created by Timur on 1/10/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
class Requests {
    static var userArray: Array = [String]()
    
//    static func getUserInfo() -> [String] {
    static func getUserInfo() {
        let accountNumber = "50179872"
//        var arrayForReturn: Array = [String]()
        guard let url = URL(string:"http://192.168.1.161:3000/api/user/card?accountNumber=\(accountNumber)") else {return}
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVjMzcwYTQzYjlkNDY1MzY2NGZlMzExMSIsImlhdCI6MTU0NzExMjkyOCwiZXhwIjoxNTQ3MTk5MzI4fQ.tj5kr71wrj2_RrdhGUEEUDU4ObZmHCW9WGldIPMtYcw"
        
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
//                print(json)
                guard let userData = json as? [String:Any] else {return}
                let user = userData["user"] as? [String:Any]
                userArray = [user?["LS"] ,user?["FIO"], user?["KOL_MAN"], user?["ADRESS"], user?["PHONE"], user?["RAYON"],user?["SCH_TYPE"]] as! [String]
                

            }catch {
                print(error)
            }
            
            }.resume()
//        return arrayForReturn
        
    }
}
