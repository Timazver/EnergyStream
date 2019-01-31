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
}

struct Ticket {
    var ticketId: String
    var date: String
    var ticketTitle: String
    var ticketMsg: String
    var ticketNumber: String
    
    init(_ ticketDic: [String: Any]) {
        let newTime = Date(timeIntervalSince1970: TimeInterval(ticketDic["createdDate"] as! Double))
        
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
        self.imgUrl = dic["imgUrl"] as! String
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
    static var listAccountNumbers: Array = [ListAccNumbers]()
    static var authToken: String = ""
    static var totalSumForPay: String = ""
    static var pdfFileName: String = ""
    static var ticketListArray: Array = [Ticket]()
    static var bankArray: Array = [Bank]()
//    static func divideFio(_ fio: String) {
//        let fioArray = fio.split(separator: " ")
//        Requests.userModel[0].firstName = String(fioArray[1])
//        Requests.userModel[0].lastName = String(fioArray[0])
//        if fioArray.count > 2 {
//        Requests.userModel[0].middleName = String(fioArray[2]) ?? "Не указано"
//        }
//    }
    
    
    static func getUserInfo(userAccNumber: String) {
        

        guard let url = URL(string:"http://192.168.1.38:3000/api/user/card?accountNumber=\(userAccNumber)") else {return}
        
        
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
        guard let url = URL(string:"http://192.168.1.38:3000/api/epd?accountNumber=\(currentAccoutNumber)") else {return}
        
        
        
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
//        self.epdTitles = epdTitles
    }
    
    
    
    //Get user object with list of Account Numbers
    static func getListAccountNumbers() {
        guard let url = URL(string:"http://192.168.1.38:3000/api/user/profile") else {return}
        
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
                
                let accountNumbersArray = user?["listAccountNumbers"] as! [[String:Any]]
                
                //Try to parse array of ListAccNumbers into array of Structure
                var model = [ListAccNumbers]()
                for list in accountNumbersArray {
                    model.append(ListAccNumbers(list))
                }
                print(Requests.listAccountNumbers.count)
                //Check if listAccountNumbers is empty, if not need to clear it
                if Requests.listAccountNumbers.isEmpty {
                    for accountNumber in model {
                        
                        Requests.listAccountNumbers.append(accountNumber)
                        
                    }
                }
            
                
                
                
                
                print(Requests.listAccountNumbers.count)
            }catch {
                print(error)
            }
            
            }.resume()
     
    }
    
//   static func getEpdFile(_ accountNumber: String) {
//        guard let url = URL(string:"http://5.63.112.4:30000/api/epd/generate") else {return}
//
//        let parameters = ["accountNumber":Requests.currentAccoutNumber]
//        var requestForEpdFile = URLRequest(url:url )
//        requestForEpdFile.httpMethod = "POST"
//        requestForEpdFile.addValue("Bearer \(Requests.authToken) ", forHTTPHeaderField: "Authorization")
//        requestForEpdFile.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
//        requestForEpdFile.httpBody = httpBody
//
//        let session = URLSession.shared
//        session.dataTask(with: requestForEpdFile) {
//            (data,response,error) in
//
//            if let response = response {
//                print(response)
//            }
//
//            guard let data = data else {return}
//            //Start testing
//
//            downloadPdf(data: data,fileName: "test")
//
//            //End of testing
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
//
//
//
//            }catch {
//                print(error)
//            }
//
//            }.resume()
//    }
    
    static func downloadPdf(data: Data, fileName: String) {

        DispatchQueue.main.async {

            let arrayUint8:[UInt8] = Array(data)
            let dataNew = Data(bytes: arrayUint8)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try? dataNew.write(to: actualPath, options: .atomic)
                print("pdf file \(pdfNameFromUrl) successfully saved!")
                self.pdfFileName = pdfNameFromUrl
            } catch {
                print("Pdf could not be saved")
            }
        }



    }
    
    
    // MARK: Add Account number function declaring
    
    static func addAccountNumber(phoneNumber: String, newAccNumber: String) {
        
        guard let url = URL(string:"http://192.168.1.38:3000/api/accountnumber/addaccountnumber") else {return}
        
        let parameters = ["accountNumber":newAccNumber, "phoneNumber":phoneNumber]
        var requestForEpdFile = URLRequest(url:url )
        requestForEpdFile.httpMethod = "POST"
        requestForEpdFile.addValue("Bearer \(Requests.authToken) ", forHTTPHeaderField: "Authorization")
        requestForEpdFile.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        requestForEpdFile.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: requestForEpdFile) {
            (data,response,error) in
            
            if let response = response {
                print(response)
            }
            
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
                
                
            }catch {
                print(error)
            }
            
            }.resume()
    }
    
    //Function that parse TicketList array
    
    static func getTicketList() {
        let headers = ["Authorization": "Bearer \(Requests.authToken)","Content-Type": "application/json"]
//        let parametersForRequest = ["]
        guard let url = URL(string: "http://192.168.1.38:3000/api/application?accountNumber=\(Requests.currentAccoutNumber)") else {return}
        
        //MARK: Request with onlu swift features
        var requestForUserInfo = URLRequest(url:url )

        requestForUserInfo.httpMethod = "GET"
        requestForUserInfo.addValue("Bearer \(Requests.authToken) ", forHTTPHeaderField: "Authorization")
        requestForUserInfo.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                guard let ticketList = json as? [[String:Any]] else {return}
                
                if Requests.ticketListArray.isEmpty {
                    for dic in ticketList {
                    ticketListArray.append(Ticket(dic))
                    }
                }
                else {
                    Requests.ticketListArray.removeAll()
                }
            }catch {
                print(error)
            }

            }.resume()
    }
    
    static func getBankList() {
        guard let url = URL(string: "http://192.168.1.38:3000/api/bank/list") else {return}
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        
        request(url, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            
            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                let bankList = value as! [[String:Any]]
                
                if self.bankArray.isEmpty {
                    for bank in bankList {
                        print(bank)
                        self.bankArray.append(Bank(bank))
                    }
                }
            }
            else {
                print("Error")
                
            }
        }
    }
}
