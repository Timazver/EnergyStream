//
//  AccNumSheetViewController.swift
//  EnergyStream
//
//  Created by Timur on 2/4/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import AKMonthYearPickerView
import iOSDropDown

class AccNumSheetViewController: UIViewController, UITextFieldDelegate {

    var dateForRequest: String = ""
//    var btnStatus:Bool = false {
//        didSet {
//            print("BtnStatus was changed")
//            self.sendBtn.isHidden = false
//            self.dateForRequest = "\(year)\(month)"
//        }
//    }
    private var year: String = ""
    private var month: String = ""
    
    @IBOutlet weak var accNumberLbl: UILabel!
    @IBOutlet weak var fioLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var yearTextField: DropDown!
    @IBOutlet weak var monthTextField: DropDown!
    
  
    
    
    @IBAction func openModalAccNumSheetVC() {
        dateForRequest = "\(year)\(month)"
        print(dateForRequest)
        if dateForRequest.isEmpty {
            let alert = UIAlertController(title: "Ошибка", message: "Вы не указали дату", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ModalAccNumSheetViewController") as! ModalAccNumSheetViewController
            vc.dateForRequest = dateForRequest
            self.addChildViewController(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sendBtn.isHidden = true
        monthTextField.optionArray = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
        yearTextField.optionArray = ["2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024","2025"]
        monthTextField.optionIds = [01,02,03,04,05,06,07,08,09,10,11,12]
        yearTextField.isSearchEnable = false
        monthTextField.isSearchEnable = false
        
        self.sendBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.sendBtn.layer.cornerRadius = 5
        self.sendBtn.layer.borderWidth = 1
        self.sendBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        self.accNumberLbl.text! = "№ \(getUserFromAccNumber(Requests.currentAccoutNumber).accountNumber)"
        self.fioLbl.text! = getUserFromAccNumber(Requests.currentAccoutNumber).fio.capitalizingFirstLetter()
        self.addressLbl.text! = getUserFromAccNumber(Requests.currentAccoutNumber).address.capitalizingFirstLetter()
        yearTextField.didSelect{(selectedText,index,id) in
            print(selectedText)
            self.year = selectedText
        }
        monthTextField.didSelect{(selectedText,index,id) in
            self.month = String(id)
        }
    }
    
    
    
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
