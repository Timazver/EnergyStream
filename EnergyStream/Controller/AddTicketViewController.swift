//
//  TicketViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/22/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import AVFoundation
import Photos

class AddTicketViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    static let shared = AddTicketViewController()
    fileprivate var currentVC: UIViewController?
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    var attachedImages = [UIImage]()
    var ticketThemes = [String]() {
        didSet {
            picker.reloadAllComponents()
        }
    }
    
    private var picker = UIPickerView()
    
    
    @IBOutlet weak var accNumberLbl: UILabel!
    @IBOutlet weak var fioTitleLbl: UILabel!
    @IBOutlet weak var fioDataLbl: UILabel!
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var addressDataLbl: UILabel!
    
    @IBOutlet weak var msgSubject: UITextField!
    @IBOutlet weak var msgTtext: UITextView!
    
    @IBOutlet weak var addBtn: UIButton!
//    @IBOutlet weak var cancelBtn: UIButton!
    
    
    @IBAction func sendTicket() {
        let title = self.msgSubject.text
        let msg = self.msgTtext.text
        let files: Array = [String]()
        let parameters = ["title":title ?? "","msg":msg ?? "","accountNumber":Requests.currentAccoutNumber,"files":files] as [String : Any]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/application") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)

            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                print("value: ", value ?? "nil")
                guard let test = value as? [String:Any] else {return}
                self.present(AlertService.showAlert(title: "Успешно", message: "Ваша заявка успешно отправлена."), animated: true, completion: nil)
            }
            else {
                print("error")
                self.present(AlertService.showAlert(title: "Ошибка", message: "Ошибка во время отправки заявки."), animated: true, completion: nil)
            }

        }
       
    }
    
    
    func getTicketThemes() {
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/dicts/applicationtypes") else {return}
        
                request(url, method: HTTPMethod.get,encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
                    guard let statusCode = responseJSON.response?.statusCode else { return }
                    print("statusCode: ", statusCode)
        
                    if (200..<300).contains(statusCode) {
                        let value = responseJSON.result.value
                        print("value: ", value ?? "nil")
                        guard let data = value as? [[String:Any]] else {return}
                        print(data)
                        for dic in data {
                            self.ticketThemes.append(dic["name"] as? String ?? "")
                        }
                        print("ticketThemes's count \(self.ticketThemes.count)")
                    }
                    else {
                       
                    }
        
                }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTicketThemes()
        //trigger the camera process
        msgSubject.inputView = picker
        picker.delegate = self
        self.navigationController!.navigationBar.backItem?.title = ""
        msgTtext.text = "Введите текст заявки"
        msgTtext.textColor = UIColor.lightGray
        
        self.title = "Создание обращения в тех. службу"
        self.msgSubject.backgroundColor = .clear
        self.msgTtext.backgroundColor = .clear
        
        self.msgSubject.layer.borderColor = UIColor.lightGray.cgColor
        self.msgSubject.layer.borderWidth = 0.4
        self.msgSubject.layer.cornerRadius = CGFloat(5)
        
        self.msgTtext.layer.borderColor = UIColor.lightGray.cgColor
        self.msgTtext.layer.borderWidth = 0.4
        self.msgTtext.layer.cornerRadius = CGFloat(5)
        self.msgSubject.useBottomBorderWithoutBackgroundColor()
//        self.msgSubject.useBottomBorderWithoutBackgroundColor()
//        self.msgTtext.useBottomBorderWithoutBackgroundColor()
        
        self.addBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.addBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
        //            UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        self.addBtn.layer.cornerRadius = 5
        self.addBtn.layer.borderWidth = 1
//        self.cancelBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
//        self.cancelBtn.layer.borderColor = UIColor(red: 0.55, green: 0.65, blue: 1.00, alpha: 1.0).cgColor
//        //            UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
//        self.cancelBtn.layer.cornerRadius = 5
//        self.cancelBtn.layer.borderWidth = 1
        
        self.accNumberLbl.text! = "№ \(Requests.currentUser.accountNumber)"
        self.fioTitleLbl.text! = "ФИО"
        self.fioDataLbl.text! = Requests.currentUser.fio.capitalizingFirstLetter()
        self.addressTitleLbl.text! = "Адрес"
        self.addressDataLbl.text! = Requests.currentUser.address.capitalizingFirstLetter()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    @IBAction func closeWindow() {
//        dismiss(animated: true, completion: nil)
//
//    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите сообщение"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        attachedImages.append(image)
//        self.dismiss(animated: true, completion: nil)
        print(attachedImages.count)
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImages() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(ticketThemes.count)
       return ticketThemes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            msgSubject.text! = ticketThemes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ticketThemes[row]
    }
    
}




