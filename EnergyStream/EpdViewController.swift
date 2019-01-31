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
        
            
    }
    
    
  
    
    //MARK: TableView datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return Requests.epdModel.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let epdCell = tableView.dequeueReusableCell(withIdentifier: "EpdCell", for: indexPath ) as! EpdCell
        var cell = UITableViewCell()
        print("tableView method was called")
        if !Requests.epdModel.isEmpty {
            if indexPath.row == 0 {
//                let titleCell = tableView.dequeueReusableCell(withIdentifier: "EpdCell", for: indexPath) as! EpdCell
                cell = tableView.dequeueReusableCell(withIdentifier: "EpdCell", for: indexPath) as! EpdCell
//                titleCell.textLabel?.text = Requests.epdModel[indexPath.section].organization
                cell.textLabel?.text = Requests.epdModel[indexPath.section].organization
            
//                return titleCell
                }
            else if indexPath.row == 1 {
//                let paymentDest = tableView.dequeueReusableCell(withIdentifier: "PaymentDestCell", for: indexPath) as! PaymentDestCell
                cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDestCell", for: indexPath) as! PaymentDestCell
//                paymentDest.textLabel?.text = ("Назначение: \(Requests.epdModel[indexPath.section].destination)")
                cell.textLabel?.text = ("Назначение: \(Requests.epdModel[indexPath.section].destination)")
//                return paymentDest
            }
            else {
//                let dataCell = tableView.dequeueReusableCell(withIdentifier: "payInfoCell", for: indexPath) as! payInfoCell
                cell = tableView.dequeueReusableCell(withIdentifier: "payInfoCell", for: indexPath) as! payInfoCell
                cell.textLabel?.text = ("К оплате: \(Requests.epdModel[indexPath.section].sumForPayment)")
//                dataCell.textLabel?.text = ("К оплате: \(Requests.epdModel[indexPath.section].sumForPayment)")

//                return dataCell
            }
        }
//        else {
//            epdTableView.reloadData()
//        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func showPopUp(sender: AnyObject) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BankChoosePopUpViewController") as! BankChoosePopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
}
