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

class AccListTableViewController: UITableViewController {
//    var logoutBtn: UIBarButtonItem!
    var contextMenuBtn: UIBarButtonItem!
    @IBOutlet weak var accListTableView: UITableView!
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
        self.navigationItem.leftBarButtonItem = contextMenuBtn
        self.navigationController?.navigationBar.tintColor = UIColor.white
        print("AccListViewController was loaded")
        accListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
       
        }
    
    @objc func showBottomAlertWindow(_ sender: Any) {
        let alert = UIAlertController(title: "Действия", message: "Выберите желаемое действие", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Добавить лицевой счет", style: .default, handler: { (_) in
            
            self.addAcc()
        }))
        
        alert.addAction(UIAlertAction(title: "Изменить пароль", style: .default, handler: { (_) in
            self.changePass()
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
            
        }))
        
        self.present(alert, animated: true, completion:nil)
    }

    func addAcc() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let AddUserFormVC = storyboard.instantiateViewController(withIdentifier: "AddUserFormViewController") as! AddUserFormViewController
        self.addChildViewController(AddUserFormVC)
        AddUserFormVC.view.frame = self.view.frame
        self.view.addSubview(AddUserFormVC.view)
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
            return 70
        }
        
        else {
            return 20
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

