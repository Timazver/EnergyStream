//
//  SocketIOManager.swift
//  EnergyStream
//
//  Created by Timur on 1/25/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
import SocketIO
import UserNotifications
import Locksmith

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
//    var manager = SocketIOManager()
////    var socket = SocketIOClient(socketURL: URL(string: "https://192.168.1.161:4300")!, config: [.log(true), .forcePolling(true)])
//    var socket = SocketIOClient(manager: self.manager, nsp: "/")
    static let manager = SocketManager(socketURL: URL(string: "http://192.168.1.161:4300")!)
    var socket = manager.defaultSocket
    var token = ""
    //generate token for socket
    
    override init() {
        super.init()
        
        
       
        socket.on("connect") { _, _ in
        print("socket connected")
            let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStream")
            self.token = dic!["token"] as! String
            self.socket.emit("auth", ["token":self.token])
        }

        socket.on("notifications") { dataArray, ack in
            
            guard let data = dataArray[0] as? [String:Any] else {return}
            print(data["greet"])
            self.pushNotification(message: data)
            
        }
        
        
    }
    func pushNotification(message: [String:Any]) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            // we're only going to create and schedule a notification
            // if the user has kept notifications authorized for this app
            guard settings.authorizationStatus == .authorized else { return }
            
            let content = UNMutableNotificationContent()
            content.title = "Тестовое сообщение"
            content.subtitle = "Exceeded balance by $300.00."
            content.body = message["greet"] as! String
            content.sound = UNNotificationSound.default()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            // create a "request to schedule a local notification, which
            // includes the content of the notification and the trigger conditions for delivery"
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    }
    func establishConnection() {
        socket.connect()
        
        
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

