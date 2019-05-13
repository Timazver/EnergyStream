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
    static let manager = SocketManager(socketURL: URL(string: "http://mobile.epotok.kz:4300")!)
    var socket = manager.defaultSocket
//    var token = ""
    //generate token for socket
    
    override init() {
        super.init()
        socket.on("connect") { _, _ in
            print("socket connected")
            let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStreamToken")
            let token = dic?["token"] as? String ?? ""
            self.socket.emit("auth", ["token":token])
        }
        
        socket.on("disconnect") { _, _ in
            print("socket disconnected")
        }
        
        socket.on("notifications") { dataArray, ack in
            guard let data = dataArray[0] as? [String:Any] else {return}
            print(dataArray)
            self.pushNotification(message:data)
            
        }
    }
    func pushNotification(message: [String:Any]) {
        print("pushNotification method was called")
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            // we're only going to create and schedule a notification
            // if the user has kept notifications authorized for this app
            guard settings.authorizationStatus == .authorized else { return }
            print("user is authorized for pushNotifications")
            let content = UNMutableNotificationContent()
            content.title = "Тестовое сообщение"
//            content.subtitle = "Exceeded balance by $300.00."
            content.body = message["msg"] as? String ?? ""
            content.sound = UNNotificationSound.default()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
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

