//
//  LicenseAgreementViewController.swift
//  EnergyStream
//
//  Created by Timur on 3/17/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class LicenseAgreementViewController: UIViewController {


    @IBOutlet weak var mainText: UITextView!
    
    func getUserAgreement() {
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/dicts/useragreement") else {return}
        let headers = ["Content-Type":"application/json"]
        request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON {responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
                print("statusCode: ", statusCode)
            guard let response = responseJSON.value else { return }
            print(response)
            guard let data = response as? [[String:Any]] else {
                print("No data")
                return
            }
            self.mainText.text! = "\(data[0]["title"] as! String) \n\n\n \(data[0]["text"] as! String) \n\n\n \(data[0]["footer"] as! String) \n\n\n\n\n\n\n\(data[1]["title"] as! String) \n\n\n \(data[1]["text"] as! String) \n\n\n \(data[1]["footer"] as! String)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserAgreement()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeWindow() {
        self.dismiss(animated: true, completion: nil)
    }

}
