//
//  ConfirmAccViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/24/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class ConfirmAccViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNumber: UITextField!
    @IBOutlet weak var secondNumber: UITextField!
    @IBOutlet weak var thirdNumber: UITextField!
    @IBOutlet weak var fourthNumber: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    var phoneNumber: String = ""
    var smsCode: String = ""
    
    @IBAction func changePass() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePassViewController") as! ChangePassViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        smsCode = "\(firstNumber.text!)\(secondNumber.text!)\(thirdNumber.text!)\(fourthNumber.text!)"
        performSegue(withIdentifier: "toChangePassVC", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNumber.delegate = self
        secondNumber.delegate = self
        thirdNumber.delegate = self
        fourthNumber.delegate = self
        firstNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        secondNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        thirdNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        fourthNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

        firstNumber.useUnderline()
        secondNumber.useUnderline()
        thirdNumber.useUnderline()
        fourthNumber.useUnderline()

        self.nextBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.nextBtn.layer.cornerRadius = 5
        self.nextBtn.layer.borderWidth = 1
        self.nextBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        
        phoneNumberField.useUnderline()
        phoneNumberField.leftViewMode = .always
        phoneNumberField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        phoneNumberField.leftView?.addSubview(UIImageView(image:UIImage(named: "phoneIcon")))
        phoneNumberField.text = phoneNumber
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 1
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return false
    }
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if text?.utf16.count==1{
            if textField == self.firstNumber {
                self.secondNumber.becomeFirstResponder()
            }
            else if textField == self.secondNumber {
                self.thirdNumber.becomeFirstResponder()
            }
            else if textField == self.thirdNumber {
                self.fourthNumber.becomeFirstResponder()
            }
            else if textField == self.fourthNumber {
                self.fourthNumber.becomeFirstResponder()
            }
        }else{
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let changePassVC = segue.destination as! ChangePassViewController
        changePassVC.phoneNumber = self.phoneNumber
        changePassVC.smsCode = self.smsCode
        
    }
    

    
    

}
