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
    var ticketListArray = [Ticket]()
    
    @IBOutlet weak var epdButton: UIButton!
    @IBOutlet weak var ticketsBtn: UIButton!
    @IBOutlet weak var accNumBtn: UIButton!
    
    //    var sections = sectionsData
    
    @IBOutlet weak var profileTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Лицевой счёт"
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.epdButton.backgroundColor = UIColor(red:0.77, green:0.90, blue:0.97, alpha:1.0)
        self.epdButton.layer.cornerRadius = 5
        self.epdButton.layer.borderWidth = 1
        self.epdButton.layer.borderColor = UIColor(red:0.65, green:0.84, blue:0.95, alpha:1.0).cgColor
        
        self.ticketsBtn.backgroundColor = UIColor(red:0.77, green:0.90, blue:0.97, alpha:1.0)
        self.ticketsBtn.layer.cornerRadius = 5
        self.ticketsBtn.layer.borderWidth = 1
        self.ticketsBtn.layer.borderColor = UIColor(red:0.65, green:0.84, blue:0.95, alpha:1.0).cgColor
        
        self.accNumBtn.backgroundColor = UIColor(red:0.77, green:0.90, blue:0.97, alpha:1.0)
        self.accNumBtn.layer.cornerRadius = 5
        self.accNumBtn.layer.borderWidth = 1
        self.accNumBtn.layer.borderColor = UIColor(red:0.65, green:0.84, blue:0.95, alpha:1.0).cgColor
        
        
        loadingViewService.setLoadingScreen(profileTableView)
        Requests.getUserInfo(userAccNumber: Requests.currentAccoutNumber)
        
//        self.getTicketList()
        
        
        
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
//        if indexPath.row == profileCellTitles.count - 1 {
//            return 200.0
//        }
//        else {
            return 60.0
//        }
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
                cell.icon.image = UIImage(named: "accNum")
            case 1:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].fio.capitalizingFirstLetter()
                cell.icon.image = UIImage(named: "fio")
            case 2:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].numberOfPeople
                cell.icon.image = UIImage(named: "numOfPeople")
            case 3:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].address.capitalizingFirstLetter()
                cell.icon.image = UIImage(named: "address")
            case 4:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].phoneNumber
                cell.icon.image = UIImage(named: "phoneNum")
            case 5:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].area.capitalizingFirstLetter()
                cell.icon.image = UIImage(named: "area")
            case 6:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = Requests.userModel[indexPath.section].SCH_TYPE
                cell.icon.image = UIImage(named: "schType")
            default:
                break
            }
            cell.tableBottomBorder()
            loadingViewService.removeLoadingScreen()
        }
            
            
        else {
            profileTableView.reloadData()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    @IBAction func segueToEpdVC(sender: Any) {
        self.performSegue(withIdentifier: "toEpdVC", sender: self)
    }
    
    @IBAction func segueToTicketVC(sender: Any) {
        self.performSegue(withIdentifier: "toTicketVC", sender: self)
    }
    
    @IBAction func segueToAccNumSheetVC(sender: Any) {
        self.performSegue(withIdentifier: "toAccNumSheet", sender: self)
    }
    
}
