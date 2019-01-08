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
    var profileCellTitles:Array = [String]()
    @IBOutlet weak var profileTableView: UITableView!
    let accountNumber = "50179872"
    var userArray: Array = [String]()
    @IBOutlet weak var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileCellTitles = ["Лицевой счет","ФИО","Количество человек","Адрес","Номер тел","Район","SCH_TYPE"]
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
        
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getUserInfo()
    }
    
    func getUserInfo() {
    
        
        guard let url = URL(string:"http://192.168.1.161:3000/api/user/profile?accountNumber=\(self.accountNumber)") else {return}
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVjMmRjZmEzN2NmZmY0MjZjZmEzNmNjZCIsImlhdCI6MTU0NjkyODEzNSwiZXhwIjoxNTQ3MDE0NTM1fQ.4vmPHsqy6NACNWJ_2jH4Ahsf5QCnw_XdaKtV-qNwrmk"
        
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
                guard let userData = json as? [String:Any] else {return}
                let user = userData["user"] as? [String:Any]
                print(user?["LS" ])
                self.userArray = [user?["LS"] as! String ,user?["FIO"] as! String, user?["KOL_MAN"] as! Int, user?["ADRESS"] as! String, user?["accountNumber"] as! String, user?["RAYON"] as! String,user?["SCH_TYPE"] as! String] as! [String]
            }catch {
                print(error)
            }
            
            }.resume()
        
        
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profileCellTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath as IndexPath) as! UserProfileCellTableViewCell
        print(indexPath)
        cell.title.text! = profileCellTitles[indexPath.row]
        cell.data.text! = userArray[indexPath.row]
        return cell
    }
    }

