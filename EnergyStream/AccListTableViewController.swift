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
    
    let contextMenu = DropDown()
    
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
        print(dic)
//        loadingViewService.setLoadingScreen(accListTableView)
        self.title = "Мои лицевые счета"
        contextMenu.anchorView = contextMenuBtn
        contextMenu.dataSource = ["Добавить лицевой счет", "Изменить пароль"]
        contextMenu.cellConfiguration = {(index,item) in return "\(item)"}
    
        contextMenuBtn = UIBarButtonItem(title:"...", style: .plain, target: self, action: #selector(showBarButtonDropDown(_:)))
        self.navigationItem.rightBarButtonItem = contextMenuBtn

        print("AccListViewController was loaded")
        accListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
       
        }
        // Do any additional setup after loading the view.
    
    @objc
    func showBarButtonDropDown(_ sender: AnyObject) {
        
        contextMenu.selectionAction = { (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
            switch index {
            case 0:
                self.addAcc()
            case 1:
                self.changePass()
            default:
                break
            }
        }
//        contextMenu.direction = .any
        contextMenu.width = 200
        contextMenu.topOffset = CGPoint(x: 0, y:-(contextMenu.plainView.bounds.height))
        contextMenu.show()
    }
    
    func addAcc() {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddUserFormViewController") as! AddUserFormViewController
                self.present(vc, animated: true, completion: nil)

    }
//
    func changePass() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PassChangeUserFormViewController") as! PassChangeUserFormViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
//    func getEpd() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "EpdViewController") as! EpdViewController
//        self.present(vc, animated: true, completion: nil)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let count = Requests.listAccountNumbers.count
//        if count == 0 {
//            accListTableView.reloadData()
//        }
        return Requests.listAccountNumbers.count
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccListCell") as! AccListCell
        if !Requests.listAccountNumbers.isEmpty {
            print("Ready for filling of cells")
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text! = "\(Requests.listAccountNumbers[indexPath.row].accountNumber) - \(Requests.listAccountNumbers[indexPath.row].FIO)"
//            loadingViewService.removeLoadingScreen()
        }
        else {
            print("listAccountNumbers array is empty")
            self.accListTableView.reloadData()
            
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell:AccListCell = tableView.cellForRow(at: indexPath) as! AccListCell
//        print(Requests.currentAccoutNumber)
//        Requests.currentAccoutNumber = (cell.textLabel?.text) ?? Requests.listAccountNumbers[0]
        performSegue(withIdentifier: "toProfileView", sender: self)
        fileName = Requests.listAccountNumbers[indexPath.row].accountNumber
        Requests.currentAccoutNumber = fileName
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
