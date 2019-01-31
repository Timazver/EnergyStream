//
//  ProfileTabBarViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/22/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    var userArray: Array = [String]()
    var profileCellTitles: Array = [String]()
    
     
    
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var epdButton: UITabBarItem!
    
    
    //    var sections = sectionsData
    
    @IBOutlet weak var profileTableView: UITableView!
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "ЕПД" {
             self.performSegue(withIdentifier: "toEpdVC", sender: self)
        }
        else if item.title == "Заявки" {
             self.performSegue(withIdentifier: "toTicketVC", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        loadingViewService.setLoadingScreen(profileTableView)
        Requests.getUserInfo(userAccNumber: Requests.currentAccoutNumber)
        
        Requests.getTicketList()
        
//        self.profileTableView.reloadData()
        self.profileCellTitles = ["Лицевой счет","ФИО","Количество человек","Адрес","Номер тел","Район","Тип счётчика"]
        if let accNumber = title {
            Requests.getUserEpd(accNumber)
        }
        //
        //
        //            self.title = "Информация о счете"
        profileTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    
    
    
    
    
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return Requests.listAccountNumbers.count
    //    }
    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCellTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath ) as! UserProfileCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        if !Requests.userModel.isEmpty {
            switch indexPath.row {
            case 0:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].accountNumber
            case 1:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].fio.capitalizingFirstLetter()
            case 2:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].numberOfPeople
            case 3:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].address
            case 4:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].phoneNumber
            case 5:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].area.capitalizingFirstLetter()
            case 6:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].SCH_TYPE
            default:
                break
            }
            cell.tableBottomBorder()
            loadingViewService.removeLoadingScreen()
        }
            
            
        else {
            profileTableView.reloadData()
        }
        
        return cell
    }
    
    // Set the activity indicator into the main view
    
}
