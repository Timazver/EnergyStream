//
//  RegisterViewController.swift
//  memuDemo
//
//  Created by Timur on 12/29/18.
//  Copyright © 2018 Parth Changela. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password:UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
//    var smsCode: String!
    //disable status bar on top
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountNumber.useUnderline()
        phoneNumber.useUnderline()
        password.useUnderline()
        confirmPassword.useUnderline()
        self.registerBtn.backgroundColor = UIColor(red:0.37, green:0.49, blue:0.90, alpha:1.0)
        self.registerBtn.layer.cornerRadius = 5
        self.registerBtn.layer.borderWidth = 1
        self.registerBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
        self.cancelBtn.backgroundColor = .clear
        self.cancelBtn.layer.cornerRadius = 5
        self.cancelBtn.layer.borderWidth = 1
        self.cancelBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
        
        // MARK: add icons to TextFields
        
        accountNumber.leftViewMode = .always
        phoneNumber.leftViewMode = .always
        password.leftViewMode = .always
        confirmPassword.leftViewMode = .always
        
        accountNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        accountNumber.leftView?.addSubview(UIImageView(image:UIImage(named: "accountNumber")))
        phoneNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        phoneNumber.leftView?.addSubview(UIImageView(image:UIImage(named: "phoneIcon")))
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        password.leftView?.addSubview(UIImageView(image:UIImage(named: "passIcon")))
        confirmPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        confirmPassword.leftView?.addSubview(UIImageView(image:UIImage(named: "passIcon")))
    }
    
    //To hide keyboard after touching outside of keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

    @IBAction func userRegister() {
        
        let accountNumber = self.accountNumber.text
        let phoneNumber = self.phoneNumber.text
        let password = self.password.text
        
        let parametersForRegister = ["phoneNumber":phoneNumber,"password":password,"accountNumber":accountNumber]
        guard let url = URL(string: "http://5.63.112.4:30000/api/register") else {return}
        
        //create session object
        
        
        //define request object
        var requestForRegister = URLRequest(url: url)
        requestForRegister.httpMethod = "POST"
        requestForRegister.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametersForRegister, options: []) else {return}
        requestForRegister.httpBody = httpBody
        print(httpBody)
        
        let session = URLSession.shared
        
        session.dataTask(with: requestForRegister) {(data,response,error) in
            
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

        let smsAlert = UIAlertController(title: "Введите смс код", message: "", preferredStyle: UIAlertControllerStyle.alert)
//
        smsAlert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Second Name"
            
            
        }
        let action=UIAlertAction(title: "Отправить", style: .default, handler:{
            action in
            guard let urlForActivate = URL(string: "http://192.168.1.161:3000/api/activate") else {return}
            let parametersForActivate = ["phoneNumber":phoneNumber,"activat Code":smsAlert.textFields![0].text]
            var requestForActivate = URLRequest(url: urlForActivate)
            requestForActivate.httpMethod = "POST"
            requestForActivate.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBodyForActivate = try? JSONSerialization.data(withJSONObject: parametersForActivate, options: []) else {return}
            requestForActivate.httpBody = httpBodyForActivate
            
            let session = URLSession.shared
            
            session.dataTask(with: requestForActivate) {(data,response,error) in
                
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
            
            
        })
        smsAlert.addAction(action)
        present(smsAlert, animated: true, completion: nil)
    }
    @IBAction func closeRegisterWindow() {
        dismiss(animated: true, completion: nil)
    }
}
