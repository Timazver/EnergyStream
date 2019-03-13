//
//  AccNumSheetViewController.swift
//  EnergyStream
//
//  Created by Timur on 2/4/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import AKMonthYearPickerView

class AccNumSheetViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

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
    private var months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    private var years = ["2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024","2025"]
    private var picker = UIPickerView()
    
    @IBOutlet weak var accNumberLbl: UILabel!
    @IBOutlet weak var fioLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    
  
    
    
    @IBAction func openModalAccNumSheetVC() {
        dateForRequest = "\(year)\(month)"
        print(dateForRequest)
        if dateForRequest.isEmpty {
            self.present(AlertService.showAlert(title: "Ошибка", message: "Вы не указали дату."), animated: true, completion: nil)
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
        picker.delegate = self
        picker.dataSource = self
        monthTextField.inputView = picker
        yearTextField.inputView = picker

        self.title = "Отчёт по ЛС"

        self.navigationController!.navigationBar.backItem?.title = ""
        self.sendBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.sendBtn.layer.cornerRadius = 5
        self.sendBtn.layer.borderWidth = 1
        self.sendBtn.layer.borderColor = UIColor(red:0.33, green:0.88, blue:0.72, alpha:1.0).cgColor
        self.accNumberLbl.text! = "№ \(Requests.currentUser.accountNumber)"
        self.fioLbl.text! = Requests.currentUser.fio.capitalizingFirstLetter()
        self.addressLbl.text! = Requests.currentUser.address.capitalizingFirstLetter()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if yearTextField.isFirstResponder {
            return years.count
        }
        
        else if monthTextField.isFirstResponder {
            return months.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if yearTextField.isFirstResponder {
            yearTextField.text! = years[row]
            year = yearTextField.text!
            yearTextField.resignFirstResponder()
        }
        else if monthTextField.isFirstResponder {
            monthTextField.text! = months[row]
            month = formatMonth(months.firstIndex(of: monthTextField.text!)! + 1)
            monthTextField.resignFirstResponder()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if yearTextField.isFirstResponder {
            return years[row]
        }
        else if monthTextField.isFirstResponder {
            return months[row]
        }
        else {
            return ""
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func formatMonth(_ month:Int) -> String {
        let month = String(month)
        if month.count == 2 {
            return month
        }
        else if month.count == 1 {
            return "0\(month)"
        }
        
        else {
          return ""
        }
    }
    
}
