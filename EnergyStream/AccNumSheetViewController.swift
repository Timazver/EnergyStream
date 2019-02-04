//
//  AccNumSheetViewController.swift
//  EnergyStream
//
//  Created by Timur on 2/4/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import AKMonthYearPickerView

class AccNumSheetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var accNumberLbl: UILabel!
    @IBOutlet weak var fioLbl: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var numberOfPeople: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    private var datePicker: UIDatePicker?
    var dateForRequest: String = ""
    @IBAction func openModalAccNumSheetVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ModalAccNumSheetViewController") as! ModalAccNumSheetViewController
        vc.dateForRequest = dateForRequest
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        
        self.sendBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.sendBtn.layer.cornerRadius = 5
        self.sendBtn.layer.borderWidth = 1
        self.sendBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        self.accNumberLbl.text! = "№ \(getUserFromAccNumber(Requests.currentAccoutNumber).accountNumber)"
        self.fioLbl.text! = getUserFromAccNumber(Requests.currentAccoutNumber).fio.capitalizingFirstLetter()
        self.addressLbl.text! = getUserFromAccNumber(Requests.currentAccoutNumber).address.capitalizingFirstLetter()
        self.numberOfPeople.text! = getUserFromAccNumber(Requests.currentAccoutNumber).numberOfPeople
        self.phoneNumber.text! = getUserFromAccNumber(Requests.currentAccoutNumber).phoneNumber
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc  func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
       
        dateFormatter.dateFormat = "MM/dd/YYYY"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.dateForRequest = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getUserFromAccNumber(_ accNumber: String) -> UserCard {
        print(accNumber)
        var currentUser = UserCard()
        for user in Requests.userModel {
            if user.accountNumber == accNumber {
                currentUser = user
            }
            
        }
        return currentUser
    }
}
