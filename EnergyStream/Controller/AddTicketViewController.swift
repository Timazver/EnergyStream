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

class AddTicketViewController: UIViewController, UITextViewDelegate {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func attachFile() {
        AddTicketViewController.shared.showAttachmentActionSheet(vc: self)
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
    
    func showAttachmentActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
            self.documentPicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        currentVC = vc
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
        case .denied:
            print("permission denied")
            self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                }else{
                    print("restriced manually")
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            })
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(attachmentTypeEnum)
        default:
            break
        }
    }
    
    func documentPicker(){
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        currentVC?.present(importMenu, animated: true, completion: nil)
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video{
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    
}
extension AddTicketViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
        
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickedBlock?(image)
        } else{
            print("Something went wrong in  image")
        }
            
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("Размер файла перед сжатием: \(Double(data.length / 1048576)) Мб")
            compressWithSessionStatusFunc(videoUrl)
            }
            else{
                print("Something went wrong in  video")
            }
            currentVC?.dismiss(animated: true, completion: nil)
        }
        
        //MARK: Video Compressing technique
        fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
            compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
                guard let session = exportSession else {
                    return
                }
                
                switch session.status {
                case .unknown:
                    break
                case .waiting:
                    break
                case .exporting:
                    break
                case .completed:
                    guard let compressedData = NSData(contentsOf: compressedURL) else {
                        return
                    }
                    print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                    
                    DispatchQueue.main.async {
                        self.videoPickedBlock?(compressedURL as NSURL)
                    }
                    
                case .failed:
                    break
                case .cancelled:
                    break
                }
            }
        }
        
        // Now compression is happening with medium quality, we can change when ever it is needed
        func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
            let urlAsset = AVURLAsset(url: inputURL, options: nil)
            guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
                handler(nil)
                
                return
            }
            
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mov
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.exportAsynchronously { () -> Void in
                handler(exportSession)
            }
        }
    }
    
    //MARK: - FILE IMPORT DELEGATE
extension AddTicketViewController: UIDocumentPickerDelegate{
        func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
            documentPicker.delegate = self
            currentVC?.present(documentPicker, animated: true, completion: nil)
        }
        
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
            print("url", url)
            self.filePickedBlock?(url)
        }
        
        //    Method to handle cancel action.
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            currentVC?.dismiss(animated: true, completion: nil)
        }
}
