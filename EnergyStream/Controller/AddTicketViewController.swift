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

class AddTicketViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    static let shared = AddTicketViewController()
    fileprivate var currentVC: UIViewController?
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    
    
    enum AttachmentType: String{
        case camera, video, photoLibrary
    }
    
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
        
//        request(url, method: HTTPMethod.post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
//            guard let statusCode = responseJSON.response?.statusCode else { return }
//            print("statusCode: ", statusCode)
//
//            if (200..<300).contains(statusCode) {
//                let value = responseJSON.result.value
//                print("value: ", value ?? "nil")
//                guard let test = value as? [String:Any] else {return}
//                self.present(AlertService.showAlert(title: "Успешно", message: "Ваша заявка успешно отправлена."), animated: true, completion: nil)
//            }
//            else {
//                print("error")
//                self.present(AlertService.showAlert(title: "Ошибка", message: "Ошибка во время отправки заявки."), animated: true, completion: nil)
//            }
//
//        }
       
    }
    
//    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((JSon?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
//        
//        let url = "http://google.com" /* your API url */
//        
//        let headers: HTTPHeaders = [
//            /* "Authorization": "your_access_token",  in case you need authorization header */
//            "Content-type": "multipart/form-data"
//        ]
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in parameters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
//            
//            if let data = imageData{
//                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
//            }
//            
//        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
//            switch result{
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    print("Succesfully uploaded")
//                    if let err = response.error{
//                        onError?(err)
//                        return
//                    }
//                    onCompletion?(nil)
//                }
//            case .failure(let error):
//                print("Error in upload: \(error.localizedDescription)")
//                onError?(error)
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //trigger the camera process
        
        
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
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func selectImages() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
}




