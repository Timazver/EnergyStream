//
//  MessageViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController,UINavigationBarDelegate,UINavigationControllerDelegate {
    let accountNumber = "50179872"
    @IBOutlet weak var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        revealViewController().rearViewRevealWidth = 200
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getUserEpd()
    }
    func getUserEpd() {
    guard let url = URL(string:"http://192.168.1.161:3000/api/user/epd?accountNumber=\(self.accountNumber)") else {return}
    
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
    let user = userData["addr_info"] as? [String:Any]
//    
    }catch {
    print(error)
    }
    
    }.resume()
    }
}
