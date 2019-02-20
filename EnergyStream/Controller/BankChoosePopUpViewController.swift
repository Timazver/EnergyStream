//
//  BankChoosePopUpViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/28/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Alamofire



class BankChoosePopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bankListTableview: UITableView!
//    var kaspiImageUrl: URL!
//    var halykImageUrl: URL!
//    var kaspiImage: Data!
//    var halykImage: Data!
    var URLForWebView: String!
    
    var bankArray: Array = [Bank]() {
        didSet {
            self.bankListTableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bankListTableview.tableHeaderView = self.createHeaderView()
        self.bankListTableview.tableHeaderView?.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
        self.navigationController!.navigationBar.backItem?.title = ""
        self.title = "Онлайн оплата"
        self.getBankList()
        self.bankListTableview.separatorStyle = .none
        loadingViewService.setLoadingScreen(bankListTableview)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        let newVC = segue.destination as! WebViewController
        newVC.url = self.URLForWebView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.bankArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section != self.bankArray.count - 1 {
//            return 10
//        }
//        else {
//            return 250
//        }
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        URLForWebView = self.bankArray[indexPath.section].link
        performSegue(withIdentifier: "toWebView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankListCell", for: indexPath) as! BankListCell
//        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
//        cell.layer.shadowOpacity = 0.3
       
        print("bankArray count is \(self.bankArray.count)")
        let imageUrl = URL(string: self.bankArray[indexPath.section].imgUrl)
        var image: Data!
        do {
            image = try  Data.init(contentsOf: imageUrl ?? URL(fileURLWithPath: ""))
        }
        catch {
            print("Ошибка загрузки изображения")
        }
        
        cell.bankBtn.setBackgroundImage(UIImage(data:image), for: UIControlState.normal)
        loadingViewService.removeLoadingScreen()
        return cell
    }
    
    
    
    func getBankList() {
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/bank/list") else {return}
        let headers = ["Authorization": "Bearer \(Requests.authToken)",
            "Content-Type": "application/json"]
        
        request(url, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            
            if (200..<300).contains(statusCode) {
                let value = responseJSON.result.value
                let bankList = value as! [[String:Any]]
                
                if self.bankArray.isEmpty {
                    for bank in bankList {
                        print(bank)
                        self.bankArray.append(Bank(bank))
                    }
                }
            }
            else {
                print("Error")
                
            }
        }
    }
    
    func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
        headerView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(headerView)
        
        let viewForElements = UIView(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: 150))
        viewForElements.backgroundColor = UIColor.white
        viewForElements.layer.shadowOpacity = 0.18
        viewForElements.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewForElements.layer.shadowRadius = 2
        viewForElements.layer.shadowColor = UIColor.black.cgColor
        viewForElements.layer.masksToBounds = false
        headerView.addSubview(viewForElements)
        
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
        fioDataLbl.text = Requests.currentUser.fio.capitalizingFirstLetter()
        
        let addressTitleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        addressTitleLbl.numberOfLines = 0
        addressTitleLbl.font = UIFont.systemFont(ofSize: 13.0)
        addressTitleLbl.textColor = UIColor.lightGray
        addressTitleLbl.text = "Адрес"
        
        let addressDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        addressDataLbl.numberOfLines = 0
        addressDataLbl.font = UIFont(name: "PT Sans Caption", size: 19.0)
        addressDataLbl.textColor = UIColor.black
        addressDataLbl.text = Requests.currentUser.address.capitalizingFirstLetter()
        
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
        accNumImageView.topAnchor.constraint(equalTo: viewForElements.topAnchor, constant: 15).isActive = true
        accNumImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        accNumImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let fioImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 15))
        viewForElements.addSubview(fioImageView)
        fioImageView.image = UIImage(named: "fio")
        //add contraints
        fioImageView.translatesAutoresizingMaskIntoConstraints = false
        fioImageView.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 15).isActive = true
        fioImageView.topAnchor.constraint(equalTo: accNumImageView.topAnchor, constant: 45).isActive = true
        fioImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        fioImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let addressImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        viewForElements.addSubview(addressImageView)
        addressImageView.image = UIImage(named: "address")
        //add contraints
        addressImageView.translatesAutoresizingMaskIntoConstraints = false
        addressImageView.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 15).isActive = true
        addressImageView.topAnchor.constraint(equalTo: fioImageView.topAnchor, constant: 50).isActive = true
        addressImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        addressImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return headerView
    }
    

}
