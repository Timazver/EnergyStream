//
//  AccListTableViewController.swift
//  memuDemo
//
//  Created by Timur on 1/17/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class AccListTableViewController: UITableViewController, UITextFieldDelegate {
//    var logoutBtn: UIBarButtonItem!
    var contextMenuBtn: UIBarButtonItem!
    @IBOutlet weak var accListTableView: UITableView!
    private var accNum = ""
    private var textField: UITextField!
 
//    let vcTitle = "Список лицевых счетов"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Список лицевых счетов"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        do {
//        try Locksmith.deleteDataForUserAccount(userAccount: "energyStream")
//        }
//        catch {
//
//        }
    
//        self.textField.delegate = self
        loadingViewService.setLoadingScreen(accListTableView)
        self.accListTableView.tableHeaderView = createHeaderView()
        self.getListAccountNumbers()
        accListTableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.0)
        self.title = "Список лицевых счетов"
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.06, blue:0.27, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
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
        
//        alert.addAction(UIAlertAction(title: "Добавить лицевой счет", style: .default, handler: { (_) in
//
//            self.addAcc(sender: self)
//        }))
        
        alert.addAction(UIAlertAction(title: "Изменить пароль", style: .default, handler: { (_) in
            self.changePass()
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
            
        }))
        
        self.present(alert, animated: true, completion:nil)
    }

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
//            cell.layer.masksToBounds = true
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Requests.currentUser = self.getUserFromAccNumber(self.listAccountNumbers[indexPath.section].accountNumber)
        self.accNum = self.listAccountNumbers[indexPath.section].accountNumber
        performSegue(withIdentifier: "toProfileView", sender: self)
        
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 220
//        }
//
//        else {
//            return 20
//        }
        return 20
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        guard let identifier = segue.identifier else { return }
        switch identifier {
            case "toProfileView":
                let profileVC = segue.destination as! ProfileViewController
                profileVC.accNumber = accNum
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
            print(data)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                guard let userData = json as? [String:Any] else { return }
                guard let user = userData["user"] as? [String:Any] else { return }
                guard let accArray = user["listAccountNumbers"] as? [[String:Any]] else { return }
                if accArray.isEmpty {
                    AlertService.showAlert(title: "Ошибка", message: "Список лицевых счетов пустой. Пожалуйста добавьте лицевой счет")
                }
                else {
                Requests.currentAccoutNumber = accArray[0]["accountNumber"] as! String
                
                let accountNumbersArray = user["listAccountNumbers"] as! [[String:Any]]
                
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
                else {
                    self.listAccountNumbers.removeAll()
                    for accountNumber in model {
                        print(accountNumber)
                        self.listAccountNumbers.append(accountNumber)
                        
                    }
                }
                }
            }catch {
                print(error)
            }
            
            }.resume()
        
    }
    
    @objc func addAccountNumber(sender:Any) {
        
        guard let url = URL(string:"\(Constants.URLForApi ?? "")/api/accountnumber/addaccountnumber") else {return}
        let parameters = ["accountNumber":textField.text!]
        let headers = ["Authorization":"Bearer \(Requests.authToken)","Content-Type":"application/json"]
        
        request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            guard let response = responseJSON.value else { return}
            print(response)
            if (200..<300).contains(statusCode) {
                self.present(AlertService.showAlert(title: "Успешно", message: "Лицевой счёт был успешно добавлен."), animated: true, completion: nil)
                self.getListAccountNumbers()
                DispatchQueue.main.async {
                    self.accListTableView.reloadData()
                    
                }
                
            }
                
            else if statusCode == 500 {
                self.present(AlertService.showAlert(title: "Ошибка", message: "Лицевой счёт уже в списке."), animated: true, completion: nil)
            }
                
            else if statusCode == 404 {
                self.present(AlertService.showAlert(title: "Ошибка", message: "Лицевой счёт не найден в базе."), animated: true, completion: nil)
            }
        }
        self.textField.text! = ""
        self.textField.resignFirstResponder()
    }

    func getUserFromAccNumber(_ accNumber: String) -> UserCard {
        let vc = ProfileViewController()
        print(accNumber)
        var currentUser = UserCard()
        for user in vc.userModel {
            if user.accountNumber == accNumber {
                currentUser = user
            }
            
        }
        return currentUser
    }

    func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        headerView.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        self.view.addSubview(headerView)
        
        let viewForElements = UIView(frame: CGRect(x: 10, y: 10, width: headerView.frame.width - 20, height: 170))
        viewForElements.backgroundColor = UIColor.white
        viewForElements.layer.shadowOpacity = 0.18
        viewForElements.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewForElements.layer.shadowRadius = 2
        viewForElements.layer.shadowColor = UIColor.black.cgColor
        viewForElements.layer.masksToBounds = false
        headerView.addSubview(viewForElements)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        headerView.addSubview(imageView)
        imageView.image = UIImage(named: "accNum")
        //add contraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
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
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: viewForElements.frame.width - 20, height: 40))
        
        textField.placeholder = "Введите номер счета"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = UIColor.black
        viewForElements.addSubview(textField)
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor(red:0.37, green:0.49, blue:0.90, alpha:1.0).cgColor
        textField.useBottomBorderWithoutBkgColor()
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
        addBtn.addTarget(self, action: #selector(self.addAccountNumber(sender:)), for:.touchUpInside)
        viewForElements.addSubview(addBtn)
        
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.topAnchor.constraint(equalTo: viewForElements.topAnchor, constant: 100.0).isActive = true
        addBtn.leadingAnchor.constraint(equalTo: viewForElements.leadingAnchor, constant: 10).isActive = true
        addBtn.trailingAnchor.constraint(equalTo: viewForElements.trailingAnchor, constant: -10).isActive = true
        addBtn.layer.cornerRadius = CGFloat(5)
        addBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return headerView
    }

    func deleteRequest(accountNumber: String) {
        let parameters = ["accountNumber":accountNumber]
        let headers = ["Authorization":"Bearer \(Requests.authToken)","Content-Type":"application/json"]
        guard let url = URL(string: "\(Constants.URLForApi ?? "")/api/accountnumber/delete") else {return}
        
        request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode: ", statusCode)
            guard let response = responseJSON.value else { return}
            print(response)
            if (200..<300).contains(statusCode) {
                self.present(AlertService.showAlert(title: "Успешно", message: "Лицевой счёт был успешно удалён."), animated: true, completion: nil)
            }
            else  if statusCode == 403 {
                self.present(AlertService.showAlert(title: "Ошибка", message: "Невозможно удалить данный лицевой счёт."), animated: true, completion: nil)
            }
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.deleteRequest(accountNumber: self.listAccountNumbers[indexPath.section].accountNumber)
        if self.listAccountNumbers.count > 1 {
            self.listAccountNumbers.remove(at: indexPath.section)
            let indexSet = NSMutableIndexSet()
            indexSet.add(indexPath.section)
            tableView.deleteSections((indexSet as IndexSet), with: .automatic)
        }
        
    }
    
    
}

