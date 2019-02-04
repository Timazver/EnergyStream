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
        
        print(textfieldPhoneNumber.text!)
        let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
        guard let userName = dic?["login"] else {return}
        print(userName)
        self.textfieldPhoneNumber.text! = userName as! String
        
        guard let pass = dic?["password"] else {return}
        self.password.text! = pass as! String
        
//     print(Locksmith.loadDataForUserAccount(userAccount: "EnergyStream"))
//        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//        self.indicator.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        self.indicator.center = view.center
//        self.indicator.transform = CGAffineTransform(scaleX: 3, y: 3)
//        self.view.addSubview(indicator)
//        self.view.bringSubview(toFront: indicator)
//        self.textfieldPhoneNumber.text = ""
//        self.password.text = ""
        textfieldPhoneNumber.useUnderline()
        password.useUnderline()
        textfieldPhoneNumber.leftViewMode = .always
        password.leftViewMode = .always
        textfieldPhoneNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        textfieldPhoneNumber.leftView?.addSubview(UIImageView(image:UIImage(named: "phoneIcon")))
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        password.leftView?.addSubview(UIImageView(image:UIImage(named: "passIcon")))
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//
    @IBAction func userLogin() {
        let login = self.textfieldPhoneNumber.text!.removingWhitespaces()
        let password = self.password.text
        
        //MARK : Trying to save credentials and token to keychain
        //Create object of Credentials structure type
        let parameters = ["phoneNumber":login,"password":password]
        let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
        if dic?["login"] as! String == login {
            
        }
        else {
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
        guard let url = URL(string: "http://192.168.1.38:3000/api/login") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            print(login)
            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                let jsonData = value as! [String:Any]
                
                guard let token = jsonData["token"] as? String else {return}
                if token != "" {
                    do {
                        Requests.authToken = token
//                        try Locksmith.updateData(data: ["token":token], forUserAccount: "energyStream")
//                        Requests.authToken = Locksmith.loadDataForUserAccount(userAccount: "energyStream")!["token"] as! String
                    }
                    catch {
                        print("Unable to save data to keychain")
                    }
                    
//                        Requests.authToken = jsonData["token"] as! String
                    print(type(of: token))
                    
                    }
                guard let auth = jsonData["auth"] as? Bool else {return}
                    if auth == true {
                        print("Successfully logged in")
                        Requests.getListAccountNumbers()

                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                        self.performSegue(withIdentifier: "accListSegue", sender: self)
                            })

                        print(Requests.currentAccoutNumber)
//                        self.enterMainWindowAfterLogin(self)
                        
                       
                    }
           
                print("value: ", value ?? "nil")
            } else {
                print("error")
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

  
        
    
    
    //MARK Trying to create seue for next ViewController
//    func enterMainWindowAfterLogin(_ sender: Any) {
//        performSegue(withIdentifier: "accListSegue", sender: self)
//    }
}
