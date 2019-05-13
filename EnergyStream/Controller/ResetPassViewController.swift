//
//  ForgotPassViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/24/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class ResetPassViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var getSmsBtn: UIButton!
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getSmsCode() {
        let parameters = ["phoneNumber":phoneNumber.text!.removingWhitespaces()]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/forgot") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            
                if (200..<300).contains(statusCode) {
                    let value = responseJSON.result.value
                }
                else {
                    print("error")
                }
        
            }
        performSegue(withIdentifier: "toConfirmAccVC", sender: self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.numberOfLines = 0
        
        self.getSmsBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.getSmsBtn.layer.cornerRadius = 5
        self.getSmsBtn.layer.borderWidth = 1
        self.getSmsBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        phoneNumber.useUnderline()
        phoneNumber.leftViewMode = .always
        phoneNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        phoneNumber.leftView?.addSubview(UIImageView(image:UIImage(named: "phoneIcon")))

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let confirmAccVC = segue.destination as! ConfirmAccViewController
        confirmAccVC.phoneNumber = self.phoneNumber.text!.removingWhitespaces()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
