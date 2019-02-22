//
//  ViewControllerForTest.swift
//  EnergyStream
//
//  Created by Timur on 2/22/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewControllerForTest: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func touchIdAction(_ sender: UIButton) {
        
        print("hello there!.. You have clicked the touch ID")
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Используйте отпечаток пальца для входа в приложение"
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            print("Awesome!!... User authenticated successfully")
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            print("Sorry!!... User did not authenticate successfully")
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                print("Sorry!!.. Could not evaluate policy.")
            }
        } else {
            // Fallback on earlier versions
            
            print("Ooops!!.. This feature is not supported.")
        }
        
        
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
