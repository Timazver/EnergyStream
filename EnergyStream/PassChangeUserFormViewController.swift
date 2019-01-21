//
//  PassChangeUserFormViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/21/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
class PassChangeUserFormViewController: UIViewController {

    @IBOutlet weak var currentPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var newPassAgain: UITextField!
    
    @IBAction func saveNewPass(_ sender: Any) {
        let oldPassword = self.currentPass.text
        let newPassword = self.newPass.text
        let repeatedPassword = self.newPassAgain.text
        let message = ""
        if newPassword != repeatedPassword {
            let alertController = UIAlertController(title: "Ошибка", message: "Введенные пароли не совпадают", preferredStyle: .alert)
            let action=UIAlertAction(title: "Ок", style: .default, handler:{
                action in})
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
        let parameters = ["oldPassword":oldPassword,"newPassword":newPassword,"repeatedPassword":repeatedPassword]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        
        guard let url = URL(string: "http://5.63.112.4:30000/api/changepass") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            
            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                print("value: ", value ?? "nil")
                let alertController = UIAlertController(title: "Успех", message: "Пароль был успешно сменен", preferredStyle: .alert)
                let action=UIAlertAction(title: "Ок", style: .default, handler:{
                    action in})
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("error")
            }
        }
    }
    @IBAction func closeWindow() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Изменить пароль"
        // Do any additional setup after loading the view.
    }
    

    
    
}
