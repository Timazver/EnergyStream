//
//  TicketViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/22/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
class AddTicketViewController: UIViewController {

    @IBOutlet weak var msgSubject: UITextField!
    @IBOutlet weak var msgTtext: UITextField!
    
    @IBAction func sendTicket() {
        let title = self.msgSubject.text
        let msg = self.msgTtext.text
        
        
        let parameters = ["title":title,"msg":msg,"accountNumber":Requests.currentAccoutNumber]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        
        guard let url = URL(string: "http://192.168.1.38:3000/api/application") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            
            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                print("value: ", value ?? "nil")
                guard let test = value as? [String:Any] else {return}
                let alertController = UIAlertController(title: "Успешно", message: "Ваша заявка успешно отправлена", preferredStyle: .alert)
                let action=UIAlertAction(title: "Ок", style: .default, handler:{
                    action in})
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                print("error")
                let alertController = UIAlertController(title: "Ошибка", message: "Ошибка во время отправки заявки", preferredStyle: .alert)
                let action=UIAlertAction(title: "Ок", style: .default, handler:{
                    action in})
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.closeWindow()
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Создание обращения в техническую службу"
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func closeWindow() {
        dismiss(animated: true, completion: nil)
        
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