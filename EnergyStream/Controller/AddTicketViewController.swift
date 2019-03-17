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

class AddTicketViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    

    static let shared = AddTicketViewController()
    @IBOutlet weak var collectionView:UICollectionView!
    
    //MARK: - Internal Properties
    var attachedImages = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var ticketThemes = [TicketThemeList]() {
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
        let parameters = ["title":title ?? "","msg":msg ?? "","accountNumber":Requests.currentAccoutNumber]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/application") else {return}
        
        upload(multipartFormData: { multipartFormData in
            print("started to upload files")
            for item in self.attachedImages {
                if let imageData = UIImagePNGRepresentation(item) {
                    multipartFormData.append(imageData, withName: "photo")
                }
            }
            for (key,value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: url, headers:headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString { response in
                    
                    debugPrint(response)
                    }
                self.present(AlertService.showAlert(title: "Успешно", message: "Ваша заявка успешно отправлена.", handler: {action in self.navigationController?.popViewController(animated: true)}) , animated: true, completion:nil)
                
            case .failure(let encodingError):
                print("Error during uploading images")
                debugPrint(encodingError)
            }
            })
        
    
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
                            print(dic)
                            self.ticketThemes.append(TicketThemeList(dic: dic))
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
//        self.createCollectionView()
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
    
    @IBAction func selectImages() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    @IBAction func closeWindow() {
//        dismiss(animated: true, completion: nil)
//
//    }

    

}

extension AddTicketViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(ticketThemes.count)
        return ticketThemes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        msgSubject.text! = String(ticketThemes[row].id)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ticketThemes[row].name
    }
    
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
    
    
    //MARK: UiCollectionView datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if attachedImages.isEmpty {
            return 1
        }
        else {
            return attachedImages.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView.numberOfSections)
//        let section = collectionView.numberOfSections 
//        let item = collectionView.numberOfItems(inSection: section) - 1
//        let lastIndexPath = IndexPath(item: item, section: section)
//        collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
        if !attachedImages.isEmpty {
            print("Adding file miniature to collectionView")
            if indexPath.row != attachedImages.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticketCollectionViewCell", for: indexPath) as! TicketCollectionViewCell
                cell.image.layer.cornerRadius = 5
                cell.image.layer.masksToBounds = true
                cell.image.image = attachedImages[indexPath.row]
                cell.deleteItemBtn.isHidden = false
            
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addPhotoCollectionViewCell", for: indexPath) as! AddPhotoCollectionViewCell
                
                return cell
            }
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addPhotoCollectionViewCell", for: indexPath) as! AddPhotoCollectionViewCell
            
            return cell
        }
        
       
    }

}




