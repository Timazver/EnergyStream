//
//  AccListTableViewController.swift
//  memuDemo
//
//  Created by Timur on 1/17/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import DropDown
import Locksmith

class AccListTableViewController: UITableViewController, UITextFieldDelegate {
//    var logoutBtn: UIBarButtonItem!
    var contextMenuBtn: UIBarButtonItem!
    @IBOutlet weak var accListTableView: UITableView!
    private var accNum = ""
    
    private var fileName = ""
    var listAccountNumbers: Array = [ListAccNumbers]() {
        didSet {
            DispatchQueue.main.async {
                self.accListTableView.reloadData()
            }
            
        }
    }
    
    
//    let contextMenu = DropDown()
    
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingViewService.setLoadingScreen(accListTableView)
        self.getListAccountNumbers()
        accListTableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.06, blue:0.27, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
        print(dic)
        self.title = "Список"
        contextMenuBtn = UIBarButtonItem(title:". . .", style: .plain, target: self, action: #selector(showBottomAlertWindow(_:)))
        self.navigationItem.rightBarButtonItem = contextMenuBtn
        self.navigationController?.navigationBar.tintColor = UIColor.white
        print("AccListViewController was loaded")
        accListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
       
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func showBottomAlertWindow(_ sender: Any) {
        let alert = UIAlertController(title: "Действия", message: "Выберите желаемое действие", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Добавить лицевой счет", style: .default, handler: { (_) in
            
            self.addAcc(sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Изменить пароль", style: .default, handler: { (_) in
            self.changePass()
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
            
        }))
        
        self.present(alert, animated: true, completion:nil)
    }

    @objc func addAcc(sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let AddUserFormVC = storyboard.instantiateViewController(withIdentifier: "AddUserFormViewController") as! AddUserFormViewController
        
        self.addChildViewController(AddUserFormVC)
        AddUserFormVC.view.frame = self.view.frame
        self.view.addSubview(AddUserFormVC.view)
        AddUserFormVC.accountNUmber.text!  = self.accNum
        AddUserFormVC.didMove(toParentViewController: self)

    }
//
    func changePass() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PassChangeUserFormViewController") as! PassChangeUserFormViewController
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.listAccountNumbers.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccListCell") as! AccListCell
        if !self.listAccountNumbers.isEmpty {
            print("Ready for filling of cells")
            cell.accNum.numberOfLines = 0
            cell.accNum.lineBreakMode = .byWordWrapping
            cell.accNum.text! = self.listAccountNumbers[indexPath.section].accountNumber
            cell.fullName.numberOfLines = 0
            cell.fullName.lineBreakMode = .byWordWrapping
            cell.fullName.text! = self.listAccountNumbers[indexPath.section].FIO.capitalizingFirstLetter()
            cell.icon.image = UIImage(named: "numOfPeople")
            loadingViewService.removeLoadingScreen()
        }
        else {
            print("listAccountNumbers array is empty")
            self.accListTableView.reloadData()
            
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Мои счета"
            
        }
            
        else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toProfileView", sender: self)
        fileName = self.listAccountNumbers[indexPath.section].accountNumber
        print(fileName)
        Requests.currentAccoutNumber = fileName
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 220
        }
        
        else {
            return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
            headerView.backgroundColor = .clear
            self.view.addSubview(headerView)
            
            let viewForElements = UIView(frame: CGRect(x: 10, y: 10, width: headerView.frame.width - 20, height: 170))
            viewForElements.backgroundColor = UIColor.white
            headerView.addSubview(viewForElements)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            headerView.addSubview(imageView)
            imageView.image = UIImage(named: "accNum")
            //add contraints
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 10).isActive = true
            imageView.topAnchor.constraint(equalTo: viewForElements.topAnchor, constant: 15).isActive = true
            
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
            label.text = "Номер лицевого счёта"
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.lightGray
            viewForElements.addSubview(label)
            //add constraints
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: viewForElements.topAnchor, constant: 10).isActive = true
            label.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 55).isActive = true
            
            //Create TextField view
            let textField = UITextField(frame: CGRect(x: 0, y: 0, width: viewForElements.frame.width - 20, height: 40))
            
            textField.placeholder = "Введите номер счета"
            textField.font = UIFont.systemFont(ofSize: 20)
            textField.textColor = UIColor.black
            viewForElements.addSubview(textField)
            textField.keyboardType = .numberPad
            textField.layer.borderColor = UIColor(red:0.37, green:0.49, blue:0.90, alpha:1.0).cgColor
            textField.useBottomBorderWithoutBkgColor()
            accNum = textField.text!
            print(accNum)
            print(textField.text!)
            //add constraints
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
            textField.topAnchor.constraint(equalTo: label.topAnchor, constant: 30).isActive = true
            textField.leftAnchor.constraint(equalTo: viewForElements.leftAnchor, constant: 55).isActive = true
            textField.rightAnchor.constraint(equalTo: viewForElements.rightAnchor, constant: -20).isActive = true
            
            let addBtn = UIButton()
            addBtn.backgroundColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
            addBtn.layer.cornerRadius = CGFloat(5)
            addBtn.setTitleColor(UIColor.white, for: .normal)
            addBtn.setTitle("Добавить лицевой счёт", for: .normal)
            addBtn.layer.borderColor = UIColor(red:0.55, green:0.65, blue:1.00, alpha:1.0).cgColor
            addBtn.addTarget(self, action: #selector(self.addAcc(sender:)), for:.touchUpInside)
            viewForElements.addSubview(addBtn)
            
            addBtn.translatesAutoresizingMaskIntoConstraints = false
            addBtn.topAnchor.constraint(equalTo: viewForElements.topAnchor, constant: 100.0).isActive = true
            addBtn.leadingAnchor.constraint(equalTo: viewForElements.leadingAnchor, constant: 10).isActive = true
            addBtn.trailingAnchor.constraint(equalTo: viewForElements.trailingAnchor, constant: -10).isActive = true
            addBtn.layer.cornerRadius = CGFloat(5)
            addBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            let headerTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            headerTitle.text = "Мои счета"
            headerTitle.font = UIFont.systemFont(ofSize: 20)
            headerView.addSubview(headerTitle)
            
            
            //add constraints
            headerTitle.translatesAutoresizingMaskIntoConstraints = false
            headerTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            headerTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
            return headerView
        }
            
        else {
            return UIView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
            case "toProfileView":
                let profileVC = segue.destination as! ProfileViewController
                profileVC.title = fileName
            
            default:
                break
        }
        
    }

    func getListAccountNumbers() {
        guard let url = URL(string:"\(Constants.URLForApi ?? "")/api/user/profile") else {return}
        
        var requestForUserInfo = URLRequest(url:url )
        
        requestForUserInfo.httpMethod = "GET"
        requestForUserInfo.addValue("Bearer \(Requests.authToken) ", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        session.dataTask(with: requestForUserInfo) {
            (data,response,error) in
            
            if let response = response {
                print(response)
            }
            
            guard let data = data else {return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let userData = json as? [String:Any] else {return}
                let user = userData["user"] as? [String:Any]
                Requests.currentAccoutNumber = user?["accountNumber"] as! String
                
                let accountNumbersArray = user?["listAccountNumbers"] as! [[String:Any]]
                
                //Try to parse array of ListAccNumbers into array of Structure
                var model = [ListAccNumbers]()
                for list in accountNumbersArray {
                    model.append(ListAccNumbers(list))
                }
                print(self.listAccountNumbers.count)
                //Check if listAccountNumbers is empty, if not need to clear it
                if self.listAccountNumbers.isEmpty {
                    for accountNumber in model {
                    print(accountNumber)
                        self.listAccountNumbers.append(accountNumber)
                        
                    }
                }
                
            }catch {
                print(error)
            }
            
            }.resume()
        
    }
    
    

}

