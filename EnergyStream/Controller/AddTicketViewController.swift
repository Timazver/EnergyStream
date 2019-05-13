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
import BSImagePicker
class AddTicketViewController: UIViewController {
    
    

//    static let shared = AddTicketViewController()
    @IBOutlet weak var collectionView:UICollectionView!
    
    
    //MARK: - Internal Properties
    var attachedImages = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        self.getTicketThemes()
        //        self.createCollectionView()
        //trigger the camera process
        msgSubject.inputView = picker
        picker.delegate = self
        self.navigationController!.navigationBar.backItem!.title = "Назад"
        msgTtext.text = "Введите текст обращения"
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
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(closePickerView))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(closePickerView))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        msgSubject.inputAccessoryView = toolBar
    }
    
    
    @IBAction func sendTicket() {
        createLoadingView()
        let title = String(findNameById(name: self.msgSubject.text ?? "").id)
        let msg = self.msgTtext.text
        let parameters = ["title":title ,"msg":msg ?? "","accountNumber":Requests.currentAccoutNumber]
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/application") else {return}
        
        upload(multipartFormData: { multipartFormData in
            print("started to upload files")
            for item in self.attachedImages {
                if let imageData = UIImageJPEGRepresentation(item, 0.5) {
                    multipartFormData.append(imageData, withName: "uploads[]", fileName: "photo", mimeType: "image/jpg")
                }
            }
            for (key,value) in parameters {
                multipartFormData.append(value  .data(using: .utf8)!, withName: key)
            }
        }, to: url, headers:headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString { response in
                    loadingViewService.removeLoadingScreen()
                    self.present(AlertService.showAlert(title: "Успешно", message: "Ваша заявка успешно отправлена.", handler: {action in
                        self.navigationController?.popViewController(animated: true)}) , animated: true, completion:nil)
                    debugPrint(response)
                    }
                
                
                
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
    
    func findNameById(id: Int) -> TicketThemeList {
        var theme = TicketThemeList()
        for item in ticketThemes {
            if item.id == id {
                theme = item
            }
        }
        return theme
    }
    
    func findNameById(name: String) -> TicketThemeList {
        var theme = TicketThemeList()
        for item in ticketThemes {
            if item.name == name {
                theme = item
            }
        }
        return theme
    }
    
    func createLoadingView() {
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        loadingView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        tableView.separatorStyle = .none
        loadingView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        tableView.layer.cornerRadius = 5
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0)
        loadingViewService.setLoadingScreen(tableView, text: "Отправка")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func closePickerView() {
        self.view.endEditing(true)
    }

    func selectImages() {
        let vc = BSImagePickerViewController()
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("User finished selecting  assets")
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            for asset in assets {
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.version = .original
                options.isSynchronous = true
                manager.requestImageData(for: asset, options: options) { data, _, _, _ in
                    if let data = data {
                        self.attachedImages.append(UIImage(data: data)!)
                    }
                }
            }
            print(self.attachedImages.count)
        }, completion: nil)
    }
    
    func takePhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func chooseSource() {
        let alert = UIAlertController(title: "", message: "Выберите источник", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { action in
            self.takePhoto(sender: self)
        }
        ))
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { action in
            self.selectImages()
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }

}

extension AddTicketViewController:UITextViewDelegate, UINavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.attachedImages.append(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(ticketThemes.count)
        return ticketThemes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        msgSubject.text! = findNameById(id: ticketThemes[row].id).name
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
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
//            return
//        }
//        attachedImages.append(image)
//        //        self.dismiss(animated: true, completion: nil)
//        print(attachedImages.count)
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    
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
                cell.deleteItemBtn.tag = indexPath.row
                cell.deleteItemBtn.addTarget(self, action: #selector(removeItem(_:)), for: .touchUpInside)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DidSelectItem method was called")
        if indexPath.count > 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ImageShowViewController") as! ImageShowViewController
            vc.configure(image: attachedImages[indexPath.row])
            present(vc, animated: true, completion: nil)
        }
       
    }
    
    @objc func removeItem(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let indexPaths = [indexPath]
        attachedImages.remove(at: sender.tag)
        collectionView.deleteItems(at: indexPaths)
        self.collectionView.reloadData()
    }
    
    

}




