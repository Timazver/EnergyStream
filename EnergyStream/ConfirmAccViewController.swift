//
//  ConfirmAccViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/24/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class ConfirmAccViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var firstNumber: UITextField!
    @IBOutlet weak var secondNumber: UITextField!
    @IBOutlet weak var thirdNumber: UITextField!
    @IBOutlet weak var fourthNumber: UITextField!
    
    var phoneNumber: String = ""
    var smsCode: String = ""
    
    @IBAction func changePass() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BankChoosePopUpViewController") as! BankChoosePopUpViewController
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
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        firstNumber.delegate = self
        secondNumber.delegate = self
        thirdNumber.delegate = self
        fourthNumber.delegate = self
        firstNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        secondNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        thirdNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        fourthNumber.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        label.numberOfLines = 0

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
        self.removeAnimate()
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

}
