//
//  AddUserFormViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/21/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class AddUserFormViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var accountNUmber: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var accNumberLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var viewForElements: UIView!
    
    @IBAction func addAcc() {
        self.addAccountNumber(phoneNumber: phoneNumber.text!.removingWhitespaces() , newAccNumber: accountNUmber.text!)
        self.removeAnimate()
    }
    
    @IBAction func closeWindow() {
        
        self.removeAnimate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.showAnimate()
        phoneNumber.useBottomBorder()
        accountNUmber.useBottomBorder()
        self.addBtn.backgroundColor = .clear
        self.addBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
        //            UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.addBtn.layer.cornerRadius = 5
        self.addBtn.layer.borderWidth = 1
        self.cancelBtn.backgroundColor = .clear
        self.cancelBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
        //            UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.cancelBtn.layer.cornerRadius = 5
        self.cancelBtn.layer.borderWidth = 1
        
        self.viewForElements.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.closeWindow()
//        self.view.endEditing(true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func addAccountNumber(phoneNumber: String, newAccNumber: String) {
        
        guard let url = URL(string:"\(Constants.URLForApi ?? "")/api/accountnumber/addaccountnumber") else {return}
        let parameters = ["accountNumber":newAccNumber, "phoneNumber":phoneNumber]
        let headers = ["Authorization":"Bearer \(Requests.authToken)","Content-Type":"application/json"]
        
        request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            if (200..<300).contains(statusCode) {
                let alert = UIAlertController(title: "Успешно", message: "Лицевой счёт был успешно добавлен.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if statusCode == 404 {
                let alert = UIAlertController(title: "Ошибка", message: "Лицевой счёт не найден в базе.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
