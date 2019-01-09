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
    
    let profileCellTitles = ["Лицевой счет","ФИО","Количество человек","Адрес","Номер тел","Район","SCH_TYPE"]
    @IBOutlet weak var profileTableView: UITableView!
    let accountNumber = "50179872"
    
    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getUserInfo()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCellTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath ) as! UserProfileCell
        print(indexPath)
        cell.title.text! = profileCellTitles[indexPath.row]
        print(userArray.count)
//        cell.data.text! = userArray[indexPath.row]
        
        return cell
    }

    
    func getUserInfo() -> [String] {
        var arrayForReturn: [String]
        guard let url = URL(string:"http://192.168.1.161:3000/api/user/profile?accountNumber=\(self.accountNumber)") else {return []}
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVjMmRjZmEzN2NmZmY0MjZjZmEzNmNjZCIsImlhdCI6MTU0NzAxNTIyMywiZXhwIjoxNTQ3MTAxNjIzfQ.9i-Qef6Tca2QyPAk-AsdmPbDJJTUPYNsw3TtklUImMo"
        
       var requestForUserInfo = URLRequest(url:url )
        requestForUserInfo.httpMethod = "GET"
        requestForUserInfo.addValue("Bearer \(token) ", forHTTPHeaderField: "Authorization")
        
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
                let user = userData["user"] as? [String:Any]
                print(user?["LS" ] as! String)
//                self.userArray
                   arrayForReturn = [user?["LS"] ,user?["FIO"], user?["KOL_MAN"], user?["ADRESS"], user?["accountNumber"], user?["RAYON"],user?["SCH_TYPE"]] as! [String]
                
                print(self.userArray)
            }catch {
                print(error)
            }
            
            }.resume()
       return arrayForReturn
        }
    
}

