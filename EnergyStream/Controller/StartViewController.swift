//
//  StartViewController.swift
//  memuDemo
//
//  Created by Timur on 12/29/18.
//  Copyright © 2018 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith
import LocalAuthentication

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textfieldPhoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    //Wind segue for logout function
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        self.textfieldPhoneNumber.text = ""
        self.password.text = ""
        Requests.authToken = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        //change buttons color and border
        self.loginBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.loginBtn.layer.cornerRadius = 5
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        self.registerBtn.backgroundColor = .clear
        self.registerBtn.layer.cornerRadius = 5
        self.registerBtn.layer.borderWidth = 1
        self.registerBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        textfieldPhoneNumber.leftViewMode = .always
        password.leftViewMode = .always
        textfieldPhoneNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        textfieldPhoneNumber.leftView?.addSubview(UIImageView(image:UIImage(named: "phoneIcon")))
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        password.leftView?.addSubview(UIImageView(image:UIImage(named: "passIcon")))
        textfieldPhoneNumber.useUnderline()
        password.useUnderline()
        print(textfieldPhoneNumber.text!)
        let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
        guard let userName = dic?["login"] else {return}
        print(userName)
        self.textfieldPhoneNumber.text! = userName as! String
        
        guard let pass = dic?["password"] else {return}
        self.password.text! = pass as! String
        self.touchInAction(login: textfieldPhoneNumber.text!)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//
    @IBAction func userLogin() {
        
        var login = self.textfieldPhoneNumber.text!.removingWhitespaces()
        var password = self.password.text!
        
        let parameters = ["phoneNumber":login,"password":password]
        
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/login") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else {
                let alert = UIAlertController(title: "", message: "Ошибка соединения с сервером", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return }
            print("statusCode: ", statusCode)
            print(login)
            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                let jsonData = value as! [String:Any]
                
                do {
                    try Locksmith.saveData(data: ["login":"test", "password":"test"], forUserAccount: "energyStream")
                }
                catch {
                    print("Cannot create userAccount \"energyStream\" ")
                }
                let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
                if dic != nil {
                    if dic?["login"] as! String == login {
                        login = dic?["login"] as! String
                        password = dic?["password"] as! String
                        
                        print("Get the if statement")
                    }
                        
                    else {
                        print("Get the else statement")
                        let alert = UIAlertController(title: "Пароль", message:"Хотите ли вы сохранить пароль?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler:{ action in
                            do {
                                try Locksmith.updateData(data: ["login":login, "password":password], forUserAccount: "energyStream")
                                
                            }
                            catch {
                                print("Unable to save token into keychain")
                                
                            }      
                        }))
                        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler:  { action in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                
                guard let token = jsonData["token"] as? String else {return}
                if token != "" {
                        Requests.authToken = token
                    }
                guard let auth = jsonData["auth"] as? Bool else {return}
                    if auth == true {
                        print("Successfully logged in")

                        self.performSegue(withIdentifier: "accListSegue", sender: self)
                    }
           
                print("value: ", value ?? "nil")
            }
            else if statusCode == 404 {
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
                
            else if statusCode == 401 {
                let alert = UIAlertController(title: "Ошибка", message: "Учётная запись не активирована.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
                
            else {
                print("Ошибка соединения с сервером. Попробуйте позднее.")
            }
            
        }
        SocketIOManager.sharedInstance.establishConnection()
    }
    @IBAction func resetPass() {
        performSegue(withIdentifier: "toResetPassVC", sender: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        guard let text = textField.text else {
            return true
        }
        
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if textfieldPhoneNumber == textField {
            textField.text = lastText.format("N (NNN) NNN NN NN", oldString: text)
            return false
        }
        return true
    }
    
    func touchInAction(login: String) {
        
        let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
        if dic != nil {
            print("login is \(login)")
            if dic?["login"] as! String == login {
                
                let myContext = LAContext()
                let myLocalizedReasonString = "Используйте отпечаток пальца для входа в приложение"
                
                var authError: NSError?
                if #available(iOS 8.0, macOS 10.12.1, *) {
                    if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                        myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                            DispatchQueue.main.async {
                                if success {
                                    // User authenticated successfully, take appropriate action
                                    self.userLogin()
                                    print("Awesome!!... User authenticated successfully")
                                } else {
                                    // User did not authenticate successfully, look at error and take appropriate action
                                    print("Sorry!!... User did not authenticate successfully")
                                }
                            }
                        }
                    } else {
                        // Could not evaluate policy; look at authError and present an appropriate message to user
                        print("Sorry!!.. Could not evaluate policy.")
                    }
                } else {
                    // Fallback on earlier versions
                    
                    print("Ooops!!.. This feature is not supported.")
                }
            }
        }
    }

    
}
