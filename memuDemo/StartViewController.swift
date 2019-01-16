//
//  StartViewController.swift
//  memuDemo
//
//  Created by Timur on 12/29/18.
//  Copyright © 2018 Parth Changela. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login.useUnderline()
        password.useUnderline()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func userLogin() {
        //define request parameters
        let login = self.login.text
        let password = self.password.text
        let parameters = ["phoneNumber":login,"password":password]
        guard let url = URL(string: "http://5.63.112.4:30000/api/login") else {return}
        print(url)
        //create session object
        
        
        //define request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Here is request")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = httpBody
        print("here is httpBdy")
        print(httpBody)
        
        let session = URLSession.shared
        
        session.dataTask(with: request) {(data,response,error) in
            
            if let response = response {
                print(response)
            }
            
            guard let data = data else {return}
            print("Here is data")
            do {
                print(data)
                //get json response from server
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print(jsonResponse)
                let jsonData = jsonResponse as! [String:Any]
                
                guard let token = jsonData["token"] else {return}
                if token != nil {
                Requests.authToken = jsonData["token"] as! String
                }
                
                
                guard let auth = jsonData["auth"] else {return}
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
                self.present(controller, animated: true, completion: nil)
                
            }catch {
                print(error)
            }
            
        }.resume()
    
}
}