//
//  ChangePassViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/24/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class ChangePassViewController: UIViewController {

    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var phoneNumber: String = ""
    var smsCode: String = ""
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.saveBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.saveBtn.layer.cornerRadius = 5
        self.saveBtn.layer.borderWidth = 1
        self.saveBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        newPassword.useUnderline()
        repeatPassword.useUnderline()
        newPassword.leftViewMode = .always
        repeatPassword.leftViewMode = .always
        newPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        newPassword.leftView?.addSubview(UIImageView(image:UIImage(named: "passIcon")))
        repeatPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        repeatPassword.leftView?.addSubview(UIImageView(image:UIImage(named: "passIcon")))
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changePassword() {
        let parameters = ["phoneNumber":phoneNumber,"activateCode":smsCode,"newPassword":newPassword.text!,"repeatedPassword":repeatPassword.text!]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/reset") else {return}
        if newPassword.text! == repeatPassword.text! {
            request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
                guard let statusCode = responseJSON.response?.statusCode else { return }
                print("statusCode: ", statusCode)
                
                if (200..<300).contains(statusCode) {
                    let value = responseJSON.result.value
                    guard let msg = value as? [String:Any] else {return}
                    
                    let alert = UIAlertController(title: "Успешно", message: "Пароль был успешно восстановлен", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: {(action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert,animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline:.now() + .seconds(4), execute: {
                        self.goBackToOneButtonTapped(self)
                    })
                    
                }
                else {
                    let alert = UIAlertController(title: "Ошибка", message: "Ошибка изменения пароля", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
                    self.present(alert,animated: true, completion: nil)
                }
                
            }
        }
        else {
            let alert = UIAlertController(title: "Ошибка", message: "Введенные пароли не совпадают", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil)
        }
        
    }
    
    func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }

}
