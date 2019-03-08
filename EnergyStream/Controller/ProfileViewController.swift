//
//  ProfileTabBarViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/22/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    var profileCellTitles: Array = [String]()
    var userModel: Array = [UserCard]() {
        didSet {
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
            }
            
        }
    }
    
    @IBOutlet weak var epdButton: UIButton!
    @IBOutlet weak var ticketsBtn: UIButton!
    @IBOutlet weak var accNumBtn: UIButton!
    @IBOutlet weak var notificationsBtn: UIButton!
    
    public var accNumber: String = ""
    
    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Лицевой счёт"
        Requests.currentAccoutNumber = self.accNumber
        loadingViewService.setLoadingScreen(profileTableView)
        self.getUserInfo(userAccNumber: self.accNumber)
        self.navigationController!.navigationBar.backItem?.title = "Назад"
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
        
        self.notificationsBtn.backgroundColor = UIColor(red:0.77, green:0.90, blue:0.97, alpha:1.0)
        self.notificationsBtn.layer.cornerRadius = 5
        self.notificationsBtn.layer.borderWidth = 1
        self.notificationsBtn.layer.borderColor = UIColor(red:0.65, green:0.84, blue:0.95, alpha:1.0).cgColor

        self.profileCellTitles = ["Лицевой счет","ФИО","Количество человек","Адрес","Номер телефона","Тип счётчика"]
        profileTableView.separatorStyle = UITableViewCellSeparatorStyle.none

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userModel.isEmpty {
            return 0
        }
        else {
//            return self.userModel[0].getPropertyCount()
            return self.profileCellTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("UserModel's count is \(self.userModel.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath ) as! UserProfileCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        if !self.userModel.isEmpty {
            switch indexPath.row {
            case 0:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = self.userModel[indexPath.section].accountNumber
                cell.data.font = UIFont.boldSystemFont(ofSize: 19.0)
                cell.icon.image = UIImage(named: "accNum")
            case 1:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = self.userModel[indexPath.section].fio.capitalizingFirstLetter()
                cell.icon.image = UIImage(named: "fio")
            case 2:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = self.userModel[indexPath.section].numberOfPeople
                cell.icon.image = UIImage(named: "numOfPeople")
            case 3:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = self.userModel[indexPath.section].address.capitalizingFirstLetter()
                cell.icon.image = UIImage(named: "address")
            case 4:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = self.userModel[indexPath.section].phoneNumber.format("N (NNN) NNN NN NN", oldString: self.userModel[indexPath.section].phoneNumber)
                cell.icon.image = UIImage(named: "phoneNum")
            case 5:
                cell.title.text! = profileCellTitles[indexPath.row]
                cell.data.text! = self.userModel[indexPath.section].SCH_TYPE
                cell.icon.image = UIImage(named: "schType")
   
            default:
                break
            }
            Requests.currentUser = self.userModel[indexPath.section]
        }
        else {
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
            }
        }
            
            cell.tableBottomBorder()
            loadingViewService.removeLoadingScreen()
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
    
    @IBAction func segueToNotificationsVC(sender: Any) {
        self.performSegue(withIdentifier: "segueToNotificationsVC", sender: self)
    }
    
    func getUserInfo(userAccNumber: String) {
        
        guard let url = URL(string:"\(Constants.URLForApi ?? "")/api/user/card?accountNumber=\(self.accNumber)") else {return}
  
        var requestForUserInfo = URLRequest(url:url)
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
                print(json)
                guard let userData = json as? [String:Any] else {return}
                
                guard let user = userData["user"] as? [String:Any] else {
                    print("User is empty")
                    return}
                
                if self.userModel.isEmpty {
                    self.userModel.append(UserCard(user))
                }
                else {
                    self.userModel.removeAll()
                }
                print(self.userModel)
                
            }catch {
                print(error)
            }
            
            }.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
}
