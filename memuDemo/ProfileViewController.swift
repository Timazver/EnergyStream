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
        profileCellTitles = ["Лицевой счет","Имя","Фамилия", "Отчество","Количество человек","Адрес","Номер тел","Район","SCH_TYPE"]
        profileTableView.estimatedRowHeight = 44.0
        profileTableView.rowHeight = UITableViewAutomaticDimension
        self.title = "Информация о счетах"
        profileTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        Requests.getListAccountNumbers()
        Requests.getUserInfo()
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
        }

    }
    
        
    
   

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Requests.listAccountNumbers.count
    }
    // Cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCellTitles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath ) as! UserProfileCell
        
        if !Requests.userModel.isEmpty {
            cell.title.text! = profileCellTitles[indexPath.row]
            switch profileCellTitles[indexPath.row] {
            case "Лицевой счет":
                cell.data.text! = Requests.userModel[0].accountNumber
            case "Имя":
                cell.data.text! = Requests.userModel[0].firstName
            case "Фамилия":
                cell.data.text! = Requests.userModel[0].lastName
            case "Отчество":
                cell.data.text! = Requests.userModel[0].middleName
            case "Количество человек":
                cell.data.text! = Requests.userModel[0].numberOfPeople
            case "Адрес":
                cell.data.text! = Requests.userModel[0].address
            case "Номер телефона":
                cell.data.text! = Requests.userModel[0].phoneNumber
            case "Район":
                cell.data.text! = Requests.userModel[0].area
            case "SCH_TYPE":
                cell.data.text! = Requests.userModel[0].SCH_TYPE
            default:
                break
            }
            print(indexPath.row)
        }
            
        
        else {
            self.profileTableView.reloadData()
        }
//        if !Requests.userArray.isEmpty {
//        cell.data.text! = Requests.userArray[indexPath.row]
//
//
//        }
//        else {
//            self.profileTableView.reloadData()
//        }

        return cell
    }
   
}


