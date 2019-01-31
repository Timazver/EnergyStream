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
    
    
    
//    let contextMenu = DropDown()
    
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accListTableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.06, blue:0.27, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
        print(dic)
//        loadingViewService.setLoadingScreen(accListTableView)
        
        self.title = "Список"
        
//        contextMenu.anchorView = contextMenuBtn
//        contextMenu.dataSource = ["Добавить лицевой счет", "Изменить пароль"]
//        contextMenu.cellConfiguration = {(index,item) in return "\(item)"}
        contextMenuBtn = UIBarButtonItem(title:". . .", style: .plain, target: self, action: #selector(showBottomAlertWindow(_:)))
        self.navigationItem.leftBarButtonItem = contextMenuBtn
        self.navigationController?.navigationBar.tintColor = UIColor.white
        print("AccListViewController was loaded")
        accListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
       
        }
        // Do any additional setup after loading the view.
    
//    @objc
//    func showBarButtonDropDown(_ sender: AnyObject) {
//
//        contextMenu.selectionAction = { (index: Int, item: String) in
////            print("Selected item: \(item) at index: \(index)")
//            switch index {
//            case 0:
//                self.addAcc()
//            case 1:
//                self.changePass()
//            default:
//                break
//            }
//        }
//        contextMenu.direction = .any
//        contextMenu.width = 140
////        contextMenu.topOffset = CGPoint(x: 0, y:-(contextMenu.plainView.bounds.height))
//        contextMenu.show()
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
    
//    func getEpd() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "EpdViewController") as! EpdViewController
//        self.present(vc, animated: true, completion: nil)
//    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Requests.listAccountNumbers.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let count = Requests.listAccountNumbers.count
//        if count == 0 {
//            accListTableView.reloadData()
//        }
        return 1
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccListCell") as! AccListCell
        
        if !Requests.listAccountNumbers.isEmpty {
            print("Ready for filling of cells")
            cell.accNum.numberOfLines = 0
            cell.accNum.lineBreakMode = .byWordWrapping
            cell.accNum.text! = Requests.listAccountNumbers[indexPath.section].accountNumber
            cell.fullName.numberOfLines = 0
            cell.fullName.lineBreakMode = .byWordWrapping
            cell.fullName.text! = Requests.listAccountNumbers[indexPath.section].FIO.capitalizingFirstLetter()
          
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
        
//        let cell:AccListCell = tableView.cellForRow(at: indexPath) as! AccListCell
//        print(Requests.currentAccoutNumber)
//        Requests.currentAccoutNumber = (cell.textLabel?.text) ?? Requests.listAccountNumbers[0]
        performSegue(withIdentifier: "toProfileView", sender: self)
        fileName = Requests.listAccountNumbers[indexPath.row].accountNumber
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
    
//    private func setupGestures() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
//        tapGesture.numberOfTapsRequired = 1
////        contextMenu.addGest
//    }
//    @objc
//    private func tapped() {
//
//    }

}

