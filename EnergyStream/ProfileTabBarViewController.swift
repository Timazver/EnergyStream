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

class ProfileViewControllerOrigin: UITableViewController {
    var userArray: Array = [String]()
    var profileCellTitles: Array = [String]()
    
//    var sections = sectionsData
    
    @IBOutlet weak var profileTableView: UITableView!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileTableView.reloadData()
        
        self.profileCellTitles = ["Лицевой счет","Имя","Фамилия", "Отчество","Количество человек","Адрес","Номер тел","Район","SCH_TYPE"]
        Requests.getUserInfo(userAccNumber: Requests.currentAccoutNumber)
        if let accNumber = title {
        Requests.getUserEpd(accNumber)
        }
//
//
//            self.title = "Информация о счете"
            profileTableView.separatorStyle = UITableViewCellSeparatorStyle.none
            Requests.getUserInfo(userAccNumber: self.title!)
        // Do any additional setup after loading the view, typically from a nib.
        

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
                                cell.textLabel?.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].accountNumber)"
                            case 1:
                                cell.textLabel?.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].firstName)"
                            case 2:
                                cell.textLabel?.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].lastName)"
                            case 3:
                                cell.textLabel?.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].middleName)"
                            case 4:
                                cell.textLabel?.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].numberOfPeople)"
                            case 5:
                                cell.textLabel?.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].address)"
                            case 6:
                                cell.textLabel?.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].phoneNumber)"
                            case 7:
                                cell.textLabel?.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].area)"
                            case 8:
                                cell.textLabel?.text! = "\(profileCellTitles[indexPath.row]): \(Requests.userModel[0].SCH_TYPE)"
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


