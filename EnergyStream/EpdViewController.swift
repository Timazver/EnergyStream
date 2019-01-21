//
//  MessageViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class EpdViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
//    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var epdTableView: UITableView!
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var buttonForPay: UIButton!
    
    @IBAction func getEpdFile() {
        Requests.getEpdFile(Requests.currentAccoutNumber)
        
        let docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last) as? NSURL
        
        //put the contents in an array.
        do {
        let contents = try (FileManager.default.contentsOfDirectory(at: docURL! as URL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles))
            for fileName in contents {
                print(type(of: fileName))
//                if fileName  "text.pdf" {
//                    print("File exists")
//                }
            }
            print(contents)
        }catch {
            print("Error in getting folder list")
        }
        
    }
//    @IBOutlet weak var energyStreamTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Начисления"
       
        Requests.getUserEpd(Requests.currentAccoutNumber)
            // Do any additional setup after loading the view.
       self.epdTableView.reloadData()
        //Requests.getListAccountNumbers()
        epdTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
            
    }

  
    
    //MARK: TableView datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return Requests.epdModel.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let epdCell = tableView.dequeueReusableCell(withIdentifier: "EpdCell", for: indexPath ) as! EpdCell
        print("tableView method was called")
//        print(Requests.epdModel)
//            if !Requests.epdModel.isEmpty {
//                if indexPath.row == 0 {
//                epdCell.title.text! = Requests.epdModel[0].organization
//    //            switch Requests.epdTitles[indexPath.row] {
//    //                case "Организация":
//    //                    epdCell.data.text! = Requests.epdModel[0].organization
//    //                case "Назначение":
//    //                    epdCell.data.text! = Requests.epdModel[0].destination
//    //                case "К оплате":
//    //                    epdCell.data.text! = Requests.epdModel[0].sumForPayment
//    //                default:
//    //                    break
//                return epdCell
//            }
//                else {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "payInfoCell") as! payInfoCell
//                    cell.sumForPay.text! = Requests.epdModel[0].sumForPayment
//                    return cell
//                }
////            print(Requests.epdData[indexPath.row])
//            }
//        else {
//            self.epdTableView.reloadData()
//        }
//        if !Requests.epdModel.isEmpty {
        if indexPath.row == 0 {
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "EpdCell", for: indexPath) as! EpdCell
            titleCell.title.text! = Requests.epdModel[indexPath.section].organization
            
            return titleCell
            }
        else {
            let dataCell = tableView.dequeueReusableCell(withIdentifier: "payInfoCell", for: indexPath) as! payInfoCell
            dataCell.sumForPay.text! = Requests.epdModel[indexPath.section].sumForPayment
            buttonForPay.setTitle("К оплате \(Requests.epdModel[indexPath.section].sumForPayment)", for: .normal)
            return dataCell
        }
        
       
        
        
    }
//    func showDropDown() {
//    let modalViewController = ModalPickerViewController()
//    modalViewController.modalPresentationStyle = .overCurrentContext
//        present(modalViewController, animated: true, completion: nil)
//    }
    
}
