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
    
    var sumForPayment: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "Начисления"
        Requests.getBankList()
        epdTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
            buttonForPay.setTitle("Оплатить   \(sumForPayment)", for: .normal)
    }
    
    
  
    
    //MARK: TableView datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return Requests.epdModel.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 60
        case 1:
            return 60
        case 2:
            return 80
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let epdCell = tableView.dequeueReusableCell(withIdentifier: "EpdCell", for: indexPath ) as! EpdCell
        var cell = UITableViewCell()
        print("tableView method was called")
        if !Requests.epdModel.isEmpty {
            if indexPath.row == 0 {
                let titleCell = tableView.dequeueReusableCell(withIdentifier: "EpdCell", for: indexPath) as! EpdCell
                titleCell.title.text! = Requests.epdModel[indexPath.section].organization
                cell = titleCell

                }
            else if indexPath.row == 1 {
                let paymentDestCell = tableView.dequeueReusableCell(withIdentifier: "PaymentDestCell", for: indexPath) as! PaymentDestCell
                paymentDestCell.payDestTitleLbl.text! = "Назначение"
                paymentDestCell.payDestDataLbl.layer.borderColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0).cgColor
                paymentDestCell.payDestDataLbl.text! = Requests.epdModel[indexPath.section].destination
                cell = paymentDestCell
            }
            else {
                let paySumCell = tableView.dequeueReusableCell(withIdentifier: "payInfoCell", for: indexPath) as! payInfoCell
                paySumCell.paySumTitleLbl.text! = "К оплате"
                paySumCell.paySumDataLbl.text! = "\(Requests.epdModel[indexPath.section].sumForPayment) тг"
                self.sumForPayment += Int(Requests.epdModel[indexPath.section].sumForPayment)!
                cell = paySumCell
            }
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 150
        }
            
        else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
            headerView.backgroundColor = .clear
            self.view.addSubview(headerView)
            
            let accNumLbl = UILabel(frame: CGRect(x: 10, y: 10, width: 150, height: 30))
            accNumLbl.numberOfLines = 0
            accNumLbl.font = UIFont.boldSystemFont(ofSize: 17.0)
            accNumLbl.textColor = UIColor.black
            accNumLbl.text = "№\(Requests.currentAccoutNumber)"
            
            let fioTitleLbl = UILabel(frame: CGRect(x: 10, y: 40, width: 150, height: 20))
            fioTitleLbl.numberOfLines = 0
            fioTitleLbl.font = UIFont.systemFont(ofSize: 13.0)
            fioTitleLbl.textColor = UIColor.black
            fioTitleLbl.text = "ФИО"
            
            let fioDataLbl = UILabel(frame: CGRect(x: 10, y: 55, width: 150, height: 30))
            fioDataLbl.numberOfLines = 0
            fioDataLbl.font = UIFont.boldSystemFont(ofSize: 19.0)
            fioDataLbl.textColor = UIColor.black
            fioDataLbl.text = self.getUserFromAccNumber(Requests.currentAccoutNumber).fio.capitalizingFirstLetter()
            
            let addressTitleLbl = UILabel(frame: CGRect(x: 10, y: 85, width: 150, height: 20))
            addressTitleLbl.numberOfLines = 0
            addressTitleLbl.font = UIFont.systemFont(ofSize: 13.0)
            addressTitleLbl.textColor = UIColor.black
            addressTitleLbl.text = "Адрес"
            
            let addressDataLbl = UILabel(frame: CGRect(x: 10, y: 100, width: 150, height: 30))
            addressDataLbl.numberOfLines = 0
            addressDataLbl.font = UIFont.boldSystemFont(ofSize: 19.0)
            addressDataLbl.textColor = UIColor.black
            addressDataLbl.text = self.getUserFromAccNumber(Requests.currentAccoutNumber).address.capitalizingFirstLetter()
            
            headerView.addSubview(accNumLbl)
            headerView.addSubview(fioTitleLbl)
            headerView.addSubview(fioDataLbl)
            headerView.addSubview(addressTitleLbl)
            headerView.addSubview(addressDataLbl)
            return headerView
        }
        
        else {
            return UIView()
        }
    }
    
    @IBAction func showPopUp(sender: AnyObject) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BankChoosePopUpViewController") as! BankChoosePopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
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


