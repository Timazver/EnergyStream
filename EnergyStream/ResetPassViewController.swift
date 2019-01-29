//
//  ForgotPassViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/24/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class ResetPassViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBAction func getSmsCode() {
        let parameters = ["phoneNumber":phoneNumber.text!]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        guard let url = URL(string: "http://192.168.1.161:3000/api/forgot") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            
                if (200..<300).contains(statusCode) {
                    let value = responseJSON.result.value
                    print("value: \(value)")
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
        phoneNumber.useUnderline()
        label.numberOfLines = 0
        

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let confirmAccVC = segue.destination as! ConfirmAccViewController
        confirmAccVC.phoneNumber = self.phoneNumber.text!
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
