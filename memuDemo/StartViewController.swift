//
//  StartViewController.swift
//  memuDemo
//
//  Created by Timur on 12/29/18.
//  Copyright © 2018 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire

class StartViewController: UIViewController {
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Wind segue for logout function
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        self.login.text = ""
        self.password.text = ""
        Requests.authToken = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.indicator.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        self.indicator.center = view.center
        self.indicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
        self.login.text = ""
        self.password.text = ""
        login.useUnderline()
        password.useUnderline()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//
    @IBAction func userLogin() {
        let login = self.login.text
        let password = self.password.text
        let parameters = ["phoneNumber":login,"password":password]
        
        
        guard let url = URL(string: "http://5.63.112.4:30000/api/login") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            
            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                let jsonData = value as! [String:Any]
                
                guard let token = jsonData["token"] else {return}
                    if token != nil {
                        Requests.authToken = jsonData["token"] as! String
                    }
                guard let auth = jsonData["auth"] as? Bool else {return}
                    if auth == true {
                        print("Successfully logged in")
                        Requests.getListAccountNumbers()
                        print(Requests.currentAccoutNumber)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
                        self.present(controller, animated: true, completion: nil)
                    }
                
                            
                print("value: ", value ?? "nil")
            } else {
                print("error")
            }
            
        }
    }
}
