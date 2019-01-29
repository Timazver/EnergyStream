//
//  ConnectSocketViewController.swift
//  EnergyStream
//
//  Created by Timur on 1/25/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import Locksmith
class ConnectSocketViewController: UIViewController {

    
    
   
    
    @IBAction func getConnection() {
//        socket.connec/t()
        
//        socket.on("notifications", callback: {data, ack in
//            print(data)
//        })
        
    }
    
    @IBAction func disconnect() {
//        socket.disconnect()
        SocketIOManager.sharedInstance.closeConnection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
        print(dic)
        
//
}
}
