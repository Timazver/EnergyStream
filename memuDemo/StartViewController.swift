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
        let parameters = ["phoneNumber":login.text,"password":password.text]
        let url = URL(string: "http://192.168.1.161:3000/api/login")!
        
        //create session object
        let session = URLSession.shared
        
        //define request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var connection = NSURLConnection(request: request, delegate: nil, startImmediately: true)
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//            guard  error == nil else {
//            return
//        }
//        guard let  data = data else {
//            return
//        }
//
//        do {
//            //create json oobject from data
//            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
//                print(json)
//            }
//        }catch let error {
//            print(error.localizedDescription)
//        }
//    })
//    task.resume()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
