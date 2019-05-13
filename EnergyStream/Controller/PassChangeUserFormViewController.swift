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

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var currentPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var newPassAgain: UITextField!
    @IBOutlet weak var currentPassLbl: UILabel!
    @IBOutlet weak var newPassLbl: UILabel!
    @IBOutlet weak var newPassAgainLbl: UILabel!
    @IBOutlet weak var viewForElements: UIView!
    
    @IBAction func saveNewPass(_ sender: Any) {
        let oldPassword = self.currentPass.text
        let newPassword = self.newPass.text
        let repeatedPassword = self.newPassAgain.text
        if newPassword != repeatedPassword {
           self.present(AlertService.showAlert(title: "Ошибка", message: "Введенные пароли не совпадают."), animated: true, completion: nil)
        }
        let parameters = ["oldPassword":oldPassword,"newPassword":newPassword,"repeatedPassword":repeatedPassword]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/changepass") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters as Parameters,encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            
            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                print("value: ", value ?? "nil")
                self.present(AlertService.showAlert(title: "Успех", message: "Пароль был успешно сменен."), animated: true, completion: nil)
            } else {
                print("error")
            }
        }
    }
    @IBAction func closeWindow() {
//        dismiss(animated: true, completion: nil)
        self.removeAnimate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Изменить пароль"
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.showAnimate()
        currentPass.useBottomBorder()
        newPass.useBottomBorder()
        newPassAgain.useBottomBorder()
        self.saveBtn.backgroundColor = .clear
        self.saveBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
//            UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.saveBtn.layer.cornerRadius = 5
        self.saveBtn.layer.borderWidth = 1
        self.cancelBtn.backgroundColor = .clear
        self.cancelBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
//            UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.cancelBtn.layer.cornerRadius = 5
        self.cancelBtn.layer.borderWidth = 1
        
        self.viewForElements.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    
    
}
