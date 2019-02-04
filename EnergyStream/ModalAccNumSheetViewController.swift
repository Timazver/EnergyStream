//
//  ModalAccNumSheetViewController.swift
//  EnergyStream
//
//  Created by Timur on 2/4/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class ModalAccNumSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var AccNumSheetTableView: UITableView!
    var accNumSheetTableTitles = [String]()
    var dateForRequest: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingViewService.setLoadingScreen(AccNumSheetTableView)
        Requests.getAccNumSheet(Requests.currentAccoutNumber, dateForRequest)
        self.view.backgroundColor = UIColor(red:0.07, green:0.12, blue:0.28, alpha:0.8)
        self.AccNumSheetTableView.separatorStyle = .none
        self.AccNumSheetTableView.layer.cornerRadius = CGFloat(5)
        self.showAnimate()
        self.accNumSheetTableTitles = ["ФИО", "Район", "Адрес", "Кол-во человек", "Номер телефона","Начало сальдо", "Счётчик начало", "Счётчик конец", "Электроэнергия по лимиту", "Оплачено","Сальдо на конец"]
        
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
        return self.accNumSheetTableTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if !Requests.accNumSheetArray.isEmpty {
            if indexPath.section == 0 {
                let exitCell = tableView.dequeueReusableCell(withIdentifier: "exitCell", for: indexPath) as! ExitTableViewCell
                cell = exitCell
            }
                
           else if indexPath.section == 1 {
                let blueTC = tableView.dequeueReusableCell(withIdentifier: "blueCell", for: indexPath) as! BlueTableViewCell
                let dateFormatterForRequest = DateFormatter()
                dateFormatterForRequest.dateFormat = "YYYYMM"
                blueTC.date.text! = dateFormatterForRequest.string(for: dateForRequest)!
                cell = blueTC
            }
            else {
                let whiteTC = tableView.dequeueReusableCell(withIdentifier: "whiteCell", for: indexPath) as! WhiteTableViewCell
                whiteTC.title.numberOfLines = 0
                whiteTC.data.numberOfLines = 0
                whiteTC.title.text = self.accNumSheetTableTitles[indexPath.row]
                if Requests.accNumSheetArray[indexPath.row].dataName == "fio" || Requests.accNumSheetArray[indexPath.row].dataName == "rn" || Requests.accNumSheetArray[indexPath.row].dataName == "addr" {
                    whiteTC.data.text = Requests.accNumSheetArray[indexPath.row].dataValue.capitalizingFirstLetter()
                } else {
                whiteTC.data.text = Requests.accNumSheetArray[indexPath.row].dataValue
                }
                print(Requests.accNumSheetArray[indexPath.row].dataValue)
                cell = whiteTC
            }
            
        }
        else {
            AccNumSheetTableView.reloadData()
        }
        loadingViewService.removeLoadingScreen()
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
}
