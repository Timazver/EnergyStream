//
//  AddUserFormViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/21/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class AddUserFormViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var accountNUmber: UITextField!
    
    
    @IBAction func addAcc() {
        Requests.addAccountNumber(phoneNumber: phoneNumber.text!, newAccNumber: accountNUmber.text!)
        Requests.getListAccountNumbers()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeWindow() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.useUnderline()
        accountNUmber.useUnderline()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
