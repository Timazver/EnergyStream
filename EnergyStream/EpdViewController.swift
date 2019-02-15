//
//  MessageViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
class EpdViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var epdTableView: UITableView!
    
//    var sumForPayment: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sumForPayment = 0
//        self.sumForPayment = self.getTotalSum()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "Единый платежный документ"
        epdTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            return 50
        case 1:
            return 60
        case 2:
            return 60
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                paymentDestCell.payDestDataLbl.layer.borderColor = UIColor.white.cgColor
                paymentDestCell.payDestDataLbl.text! = Requests.epdModel[indexPath.section].destination
                cell = paymentDestCell
            }
            else {
                let paySumCell = tableView.dequeueReusableCell(withIdentifier: "payInfoCell", for: indexPath) as! payInfoCell
                paySumCell.paySumTitleLbl.text! = "К оплате:"
                paySumCell.paySumDataLbl.text! = "\(Requests.epdModel[indexPath.section].sumForPayment) тг"
                paySumCell.translatesAutoresizingMaskIntoConstraints = false
                paySumCell.paySumDataLbl.layer.borderColor = UIColor.red.cgColor
//                self.sumForPayment += Int(Requests.epdModel[indexPath.section].sumForPayment)!
                if indexPath.section == Requests.epdModel.count - 1 {
                    paySumCell.layer.shadowOpacity = 0.18
                    paySumCell.layer.shadowOffset = CGSize(width: 0, height: 2)
                    paySumCell.layer.shadowRadius = 2
                    paySumCell.layer.shadowColor = UIColor.black.cgColor
                    paySumCell.layer.masksToBounds = false
                }
                cell = paySumCell
                
            }
        }
//        buttonForPay.setTitle("Оплатить   \(sumForPayment) тг", for: .normal)
       
        cell.selectionStyle = .none
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != Requests.epdModel.count - 1 {
            return 1
        }
        else {
            return 200
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 170
        }
            
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != Requests.epdModel.count - 1 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width))
            footerView.backgroundColor = .white
            self.view.addSubview(footerView)
            return footerView
        }
        else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width))
            footerView.backgroundColor = .clear
            self.view.addSubview(footerView)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 19.0)
            label.textColor = UIColor(red:0.20, green:0.26, blue:0.46, alpha:1.0)
            label.text = "Итого к оплате:"
            footerView.addSubview(label)
            
            let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
            textField.backgroundColor = UIColor(red:0.20, green:0.26, blue:0.46, alpha:1.0)
            textField.text! = "\(getTotalSum()) тг"
            textField.textColor = .white
            footerView.addSubview(textField)
            
            let payBtn = UIButton()
            payBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
            payBtn.layer.cornerRadius = CGFloat(5)
            payBtn.setTitleColor(UIColor.white, for: .normal)
            payBtn.setTitle("Оплатить", for: .normal)
            payBtn.layer.borderColor = UIColor(red:0.55, green:0.65, blue:1.00, alpha:1.0).cgColor
            payBtn.addTarget(self, action: #selector(self.showPopUp(sender:)), for:.touchUpInside)
            footerView.addSubview(payBtn)
            
            //add constraints
            
            payBtn.translatesAutoresizingMaskIntoConstraints = false
            payBtn.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            payBtn.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 100).isActive = true
            payBtn.widthAnchor.constraint(equalToConstant: 240).isActive = true
            payBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            label.translatesAutoresizingMaskIntoConstraints = false
            textField.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 40).isActive = true
            label.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 20).isActive = true
            label.widthAnchor.constraint(equalToConstant: 150).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            textField.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 40).isActive = true
            textField.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -20).isActive = true
            textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 90).isActive = true
            textField.textAlignment = .center
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 170))
            headerView.backgroundColor = .clear
            self.view.addSubview(headerView)
            
            let viewForElements = UIView(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: 150))
            viewForElements.backgroundColor = UIColor.white
            viewForElements.layer.shadowOpacity = 0.18
            viewForElements.layer.shadowOffset = CGSize(width: 0, height: 2)
            viewForElements.layer.shadowRadius = 2
            viewForElements.layer.shadowColor = UIColor.black.cgColor
            viewForElements.layer.masksToBounds = false
            headerView.addSubview(viewForElements)
            
            //add constraints
            //            viewForElements.translatesAutoresizingMaskIntoConstraints = false
            //            viewForElements.widthAnchor.constraint(greaterThanOrEqualToConstant: headerView.frame.width - 20).isActive = true
            //            viewForElements.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10).isActive = true
            //            viewForElements.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -10).isActive = true
            //            viewForElements.topAnchor.constraint(equalTo: headerView.topAnchor, constant: -15).isActive = true
            
            let accNumLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
            accNumLbl.numberOfLines = 0
            accNumLbl.font = UIFont.boldSystemFont(ofSize: 21.0)
            accNumLbl.textColor = UIColor.black
            accNumLbl.text = "№\(Requests.currentAccoutNumber)"
            
            let fioTitleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
            fioTitleLbl.numberOfLines = 0
            fioTitleLbl.font = UIFont.systemFont(ofSize: 13.0)
            fioTitleLbl.textColor = UIColor.lightGray
            fioTitleLbl.text = "ФИО"
            
            let fioDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
            fioDataLbl.numberOfLines = 0
            fioDataLbl.font = UIFont(name: "PT Sans Caption", size: 19.0)
            fioDataLbl.textColor = UIColor.black
            fioDataLbl.text = self.getUserFromAccNumber(Requests.currentAccoutNumber).fio.capitalizingFirstLetter()
            
            let addressTitleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
            addressTitleLbl.numberOfLines = 0
            addressTitleLbl.font = UIFont.systemFont(ofSize: 13.0)
            addressTitleLbl.textColor = UIColor.lightGray
            addressTitleLbl.text = "Адрес"
            
            let addressDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
            addressDataLbl.numberOfLines = 0
            addressDataLbl.font = UIFont(name: "PT Sans Caption", size: 19.0)
            addressDataLbl.textColor = UIColor.black
            addressDataLbl.text = self.getUserFromAccNumber(Requests.currentAccoutNumber).address.capitalizingFirstLetter()
            
            viewForElements.addSubview(accNumLbl)
            viewForElements.addSubview(fioTitleLbl)
            viewForElements.addSubview(fioDataLbl)
            viewForElements.addSubview(addressTitleLbl)
            viewForElements.addSubview(addressDataLbl)
            
            //add constraints
            accNumLbl.translatesAutoresizingMaskIntoConstraints = false
            fioTitleLbl.translatesAutoresizingMaskIntoConstraints = false
            fioDataLbl.translatesAutoresizingMaskIntoConstraints = false
            addressTitleLbl.translatesAutoresizingMaskIntoConstraints = false
            addressDataLbl.translatesAutoresizingMaskIntoConstraints = false
            
            accNumLbl.topAnchor.constraint(equalTo: viewForElements.topAnchor, constant: 10).isActive = true
            accNumLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
            
            fioTitleLbl.topAnchor.constraint(equalTo: accNumLbl.topAnchor, constant: 30).isActive = true
            fioTitleLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
            
            fioDataLbl.topAnchor.constraint(equalTo: fioTitleLbl.topAnchor, constant: 20).isActive = true
            fioDataLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
            
            addressTitleLbl.topAnchor.constraint(equalTo: fioDataLbl.topAnchor, constant: 40).isActive = true
            addressTitleLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
            
            addressDataLbl.topAnchor.constraint(equalTo: addressTitleLbl.topAnchor, constant: 20).isActive = true
            addressDataLbl.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 50).isActive = true
            

            let accNumImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 15))
            viewForElements.addSubview(accNumImageView)
            accNumImageView.image = UIImage(named: "accNum")
            //add contraints
            accNumImageView.translatesAutoresizingMaskIntoConstraints = false
            accNumImageView.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 15).isActive = true
            accNumImageView.topAnchor.constraint(equalTo: viewForElements.topAnchor, constant: 10).isActive = true
            
            let fioImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 15))
            viewForElements.addSubview(fioImageView)
            fioImageView.image = UIImage(named: "fio")
            //add contraints
            fioImageView.translatesAutoresizingMaskIntoConstraints = false
            fioImageView.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 15).isActive = true
            fioImageView.topAnchor.constraint(equalTo: accNumImageView.topAnchor, constant: 45).isActive = true
            
            let addressImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
            viewForElements.addSubview(addressImageView)
            addressImageView.image = UIImage(named: "address")
            //add contraints
            addressImageView.translatesAutoresizingMaskIntoConstraints = false
            addressImageView.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 15).isActive = true
            addressImageView.topAnchor.constraint(equalTo: fioImageView.topAnchor, constant: 50).isActive = true
            return headerView
        }
        
        else {
            let leftRightViews = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            leftRightViews.backgroundColor = .clear
            self.view.addSubview(leftRightViews)
            
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 1))
            leftView.backgroundColor = .white
            leftRightViews.addSubview(leftView)
            
            //add constraints
            leftView.translatesAutoresizingMaskIntoConstraints = false
            leftView.leftAnchor.constraint(equalTo: leftRightViews.leftAnchor, constant: 0).isActive = true
            leftView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
            leftView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 1))
            rightView.backgroundColor = .white
            leftRightViews.addSubview(rightView)
            
            //add constraints
            rightView.translatesAutoresizingMaskIntoConstraints = false
            rightView.rightAnchor.constraint(equalTo: leftRightViews.rightAnchor, constant: 0).isActive = true
            rightView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
            rightView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
            return leftRightViews
        }
    }
    
    @IBAction func showPopUp(sender: AnyObject) {
        print("showPopUp method was called")
        performSegue(withIdentifier: "toBankChooseVC", sender: self)
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
    
    func getTotalSum() -> Int {
        var sum = 0
        for edp in Requests.epdModel {
            sum += Int(edp.sumForPayment) ?? 0
        }
        return sum
        
    }
    
}


