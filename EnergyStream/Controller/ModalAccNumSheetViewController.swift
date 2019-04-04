//
//  ModalAccNumSheetViewController.swift
//  EnergyStream
//
//  Created by Timur on 2/4/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire
class ModalAccNumSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var AccNumSheetTableView: UITableView!
//    var accNumSheetTableTitles = [String]()
    var dateForRequest: String = ""
    var accNumSheetArray: Array = [AccNumSheet]() {
        didSet {
            self.AccNumSheetTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingViewService.setLoadingScreen(AccNumSheetTableView)
        print(dateForRequest)
        self.getAccNumSheet(Requests.currentAccoutNumber, dateForRequest as String)
        self.view.backgroundColor = UIColor(red:0.07, green:0.12, blue:0.28, alpha:0.8)
        self.AccNumSheetTableView.separatorStyle = .none
        self.AccNumSheetTableView.layer.cornerRadius = CGFloat(5)
        self.showAnimate()
//        self.accNumSheetTableTitles = ["ФИО", "Район", "Адрес", "Кол-во человек", "Номер телефона","Начало сальдо", "Счётчик начало", "Счётчик конец", "Электроэнергия по лимиту", "Оплачено","Сальдо на конец"]
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeWindow() {
        self.removeAnimate()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        else {
            return self.accNumSheetArray.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if !self.accNumSheetArray.isEmpty {
            if indexPath.section == 0 {
                let exitCell = tableView.dequeueReusableCell(withIdentifier: "exitCell", for: indexPath) as! ExitTableViewCell
                cell = exitCell
            }
                
           else if indexPath.section == 1 {
                let blueTC = tableView.dequeueReusableCell(withIdentifier: "blueCell", for: indexPath) as! BlueTableViewCell
                dateForRequest.insert("/", at: dateForRequest.index(dateForRequest.startIndex, offsetBy:4))
                blueTC.date.text! = dateForRequest
                cell = blueTC
            }
            else {
                let whiteTC = tableView.dequeueReusableCell(withIdentifier: "whiteCell", for: indexPath) as! WhiteTableViewCell
                whiteTC.title.numberOfLines = 0
                whiteTC.data.numberOfLines = 0
                whiteTC.title.text = self.accNumSheetArray[indexPath.row].dataName
                if self.accNumSheetArray[indexPath.row].dataName == "ФИО абонента" || self.accNumSheetArray[indexPath.row].dataName == "Район" || self.accNumSheetArray[indexPath.row].dataName == "Адрес" {
                    whiteTC.data.text = self.accNumSheetArray[indexPath.row].dataValue.capitalizingFirstLetter()
                }
                else if self.accNumSheetArray[indexPath.row].dataName == "Номер телефона абонента" {
                    whiteTC.data.text = self.accNumSheetArray[indexPath.row].dataValue.format("N (NNN) NNN NN NN", oldString: self.accNumSheetArray[indexPath.row].dataValue)
                    
                }
                else {
                whiteTC.data.text = self.accNumSheetArray[indexPath.row].dataValue
                }
                print(self.accNumSheetArray[indexPath.row].dataValue)
                cell = whiteTC
            }
            
        } 
        else {
            AccNumSheetTableView.reloadData()
        }
        loadingViewService.removeLoadingScreen()
        cell.selectionStyle = .none
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
//    func formatDateForRequest(dateFrom: String) -> String {
//        if dateFrom != "" {
//            let dateInArr = dateFrom.split(separator: "/")
//            return "\(dateInArr[2])\(dateInArr[0])"
//        }
//        else {
//            return ""
//        }
//    }
    
    func getAccNumSheet(_ accNumber: String, _ date: String) {
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/indication") else {return}
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        let parameters = ["accountNumber":accNumber, "date":date]
        request(url, method: HTTPMethod.get, parameters: parameters, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            if (200..<300).contains(statusCode) {
                let testValue = responseJSON.result.value as? [String:NSNull]
                if  testValue?["result"] == NSNull() {
                    
                    let alert = UIAlertController(title: "Ошибка", message: "Данных за указанную дату нет", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: {(action) in
                       
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    var value = responseJSON.result.value as! [String:Any]
                    //                    if value["result"] as! NSNull != nil {
                    let accNumSheetList = value["result"] as! [[String:Any]]
                    print(accNumSheetList)
                    if self.accNumSheetArray.isEmpty {
                        for dataObj in accNumSheetList {
                            print(dataObj)
                            self.accNumSheetArray.append(AccNumSheet(dataObj))
                        }
                    }
                }
                
            }
        }
    }

}
