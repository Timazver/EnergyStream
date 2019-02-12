//
//  MainViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/29/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Locksmith

class MainViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBAction func moveToLoginWindow(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        self.present(sb.instantiateViewController(withIdentifier: "StartViewController"), animated: true, completion: nil)
    }
    
    @IBAction func moveToRegisterWindow(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        self.present(sb.instantiateViewController(withIdentifier: "RegisterViewController"), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.backgroundColor = .clear
        self.loginBtn.layer.cornerRadius = 5
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
        self.registerBtn.backgroundColor = .clear
        self.registerBtn.layer.cornerRadius = 5
        self.registerBtn.layer.borderWidth = 1
        self.registerBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
//        do {
//        try Locksmith.deleteDataForUserAccount(userAccount: "energyStream")
//        }
//        catch {
//            
//        }
        // Do any additional setup after loading the view.
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
