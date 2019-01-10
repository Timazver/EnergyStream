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
    
    @IBOutlet weak var profileTableView: UITableView!
    
    
    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        Requests.getUserInfo()
        profileCellTitles = ["Лицевой счет","ФИО","Количество человек","Адрес","Номер тел","Район","SCH_TYPE"]
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
        }

    }
    
        
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCellTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath ) as! UserProfileCell
        
        cell.title.text! = profileCellTitles[indexPath.row]
        if !Requests.userArray.isEmpty {
        cell.data.text! = Requests.userArray[indexPath.row]
        
        }
        else {
            self.profileTableView.reloadData()
        }
        
        return cell
    }

    
    

}


