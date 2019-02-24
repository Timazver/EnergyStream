//
//  RegisterViewController.swift
//  memuDemo
//
//  Created by Timur on 12/29/18.
//  Copyright © 2018 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {

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
        self.registerBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.registerBtn.layer.cornerRadius = 5
        self.registerBtn.layer.borderWidth = 1
        self.registerBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        self.cancelBtn.backgroundColor = .clear
        self.cancelBtn.layer.cornerRadius = 5
        self.cancelBtn.layer.borderWidth = 1
        self.cancelBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        
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
        let phoneNumber = self.phoneNumber.text!.removingWhitespaces()
        let password = self.password.text
        
        let parametersForRegister = ["phoneNumber":phoneNumber,"password":password,"accountNumber":accountNumber]
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/register") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parametersForRegister, encoding: JSONEncoding.default).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print(responseJSON.value!)
            print("statusCode: ", statusCode)
            if statusCode == 200 {
                print("Появилось окно с смс")
                let smsAlert = UIAlertController(title: "Введите смс код", message: "", preferredStyle: UIAlertControllerStyle.alert)
                smsAlert.addTextField { (textField : UITextField!) -> Void in
                }
                let action=UIAlertAction(title: "Отправить", style: .default, handler:{
                    action in
                    guard let urlForActivate = URL(string: "\(Constants.URLForApi ?? "")/api/activate") else {return}
                    let parametersForActivate = ["phoneNumber":phoneNumber,"activateCode":smsAlert.textFields![0].text] as [String : Any]
                    request(urlForActivate, method: HTTPMethod.post, parameters: parametersForActivate, encoding: JSONEncoding.default).responseJSON {responseJSON in
                        guard let activateStatusCode = responseJSON.response?.statusCode else { return }
                        if activateStatusCode == 200 {
                            let alert = UIAlertController(title: "Успешно", message: "Регистрация завершилась успешно!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: {(action) in
                            self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert,animated: true, completion: nil)
                        }
                
                        else if activateStatusCode == 404 {
                            let alert = UIAlertController(title: "Ошибка", message: "Смс код неверно", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: {(action) in
                            self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert,animated: true, completion: nil)
                        }
                        }
                }
            )
                smsAlert.addAction(action)
                self.present(smsAlert, animated: true, completion: nil)
            }
            
            else if statusCode == 404 {
                let alert = UIAlertController(title: "Ошибка", message: "Лицевой счёт не найден в базе.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeRegisterWindow() {
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if phoneNumber == textField {
            textField.text = lastText.format("N (NNN) NNN NN NN", oldString: text)
            return false
        }
        return true
    }
}
