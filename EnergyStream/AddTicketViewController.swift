//
//  TicketViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/22/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
class AddTicketViewController: UIViewController {

    @IBOutlet weak var accNumberLbl: UILabel!
    @IBOutlet weak var fioTitleLbl: UILabel!
    @IBOutlet weak var fioDataLbl: UILabel!
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var addressDataLbl: UILabel!
    
    @IBOutlet weak var msgSubject: UITextField!
    @IBOutlet weak var msgTtext: UITextField!
    
    @IBOutlet weak var addBtn: UIButton!
//    @IBOutlet weak var cancelBtn: UIButton!
    
    
    @IBAction func sendTicket() {
        let title = self.msgSubject.text
        let msg = self.msgTtext.text
        
        
        let parameters = ["title":title,"msg":msg,"accountNumber":Requests.currentAccoutNumber]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        
        guard let url = URL(string: "http://192.168.1.38:3000/api/application") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            
            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                print("value: ", value ?? "nil")
                guard let test = value as? [String:Any] else {return}
                let alertController = UIAlertController(title: "Успешно", message: "Ваша заявка успешно отправлена", preferredStyle: .alert)
                let action=UIAlertAction(title: "Ок", style: .default, handler:{
                    action in})
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                print("error")
                let alertController = UIAlertController(title: "Ошибка", message: "Ошибка во время отправки заявки", preferredStyle: .alert)
                let action=UIAlertAction(title: "Ок", style: .default, handler:{
                    action in})
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Создание обращения в техническую службу"
        self.msgSubject.backgroundColor = .clear
        self.msgTtext.backgroundColor = .clear
        self.msgSubject.useBottomBorderWithoutBackgroundColor()
        self.msgTtext.useBottomBorderWithoutBackgroundColor()
        
        self.addBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.addBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
        //            UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.addBtn.layer.cornerRadius = 5
        self.addBtn.layer.borderWidth = 1
//        self.cancelBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
//        self.cancelBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
//        //            UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
//        self.cancelBtn.layer.cornerRadius = 5
//        self.cancelBtn.layer.borderWidth = 1
        
        self.accNumberLbl.text! = "№ \(getUserFromAccNumber(Requests.currentAccoutNumber).accountNumber)"
        self.fioTitleLbl.text! = "ФИО"
        self.fioDataLbl.text! = getUserFromAccNumber(Requests.currentAccoutNumber).fio.capitalizingFirstLetter()
        self.addressTitleLbl.text! = "Адрес"
        self.addressDataLbl.text! = getUserFromAccNumber(Requests.currentAccoutNumber).address.capitalizingFirstLetter()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    @IBAction func closeWindow() {
//        dismiss(animated: true, completion: nil)
//
//    }

    
    func getUserFromAccNumber(_ accNumber: String) -> UserCard {
        print(accNumber)
        var currentUser = UserCard()
        for user in Requests.userModel {
            if user.accountNumber == accNumber {
                currentUser = user
            }
            
        }
        return currentUser
    }
    

}
