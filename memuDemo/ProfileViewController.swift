//
//  ProfileViewController.swift
//  memuDemo
//
//  Created by Timur on 1/8/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
//Declarew structure User to create container with data from server
//struct User {
//    var accountNumber: String
//    var FIO: String
//    var numberOfPeople: Int
//    var userAddress:String
//    var phoneNumber: String
//    var area: String
//    var SCH_TYPE: String
//}

class ProfileViewController: UITableViewController {
    var userArray: Array = [String]()
    var profileCellTitles: Array = [String]()
    
//    var sections = sectionsData
    
    @IBOutlet weak var profileTableView: UITableView!
    
    
    @IBOutlet weak var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
            self.profileCellTitles = ["Лицевой счет","Имя","Фамилия", "Отчество","Количество человек","Адрес","Номер тел","Район","SCH_TYPE"]
            Requests.getUserInfo(userAccNumber: Requests.currentAccoutNumber)
      
        
            self.title = "Информация о счете"
            profileTableView.separatorStyle = UITableViewCellSeparatorStyle.none
            Requests.getUserInfo(userAccNumber: Requests.currentAccoutNumber)
        // Do any additional setup after loading the view, typically from a nib.
            if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
                menu.target = revealViewController()
                menu.action = #selector(SWRevealViewController.revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
           

        }

    }
    
        
    
   

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return Requests.listAccountNumbers.count
//    }
    // Cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCellTitles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath ) as! UserProfileCell
        
        if !Requests.userModel.isEmpty && Requests.userModel[0].firstName != "" {
            
            switch indexPath.row {
                            case 0:
                                cell.title.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].accountNumber)"
                            case 1:
                                cell.title.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].firstName)"
                            case 2:
                                cell.title.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].lastName)"
                            case 3:
                                cell.title.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].middleName)"
                            case 4:
                                cell.title.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].numberOfPeople)"
                            case 5:
                                cell.title.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].address)"
                            case 6:
                                cell.title.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].phoneNumber)"
                            case 7:
                                cell.title.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].area)"
                            case 8:
                                cell.title.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].SCH_TYPE)"
                            default:
                                break
                            }
        }
            
        
        else {
            profileTableView.reloadData()
        }

        return cell
    }
   
}


