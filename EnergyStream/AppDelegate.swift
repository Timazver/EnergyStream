//
//  AppDelegate.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
import UserNotifications
import Locksmith
import SocketIO
import Firebase
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
//        application.setMinimumBackgroundFetchInterval(10)
//        registerForPushNotifications()
//        SocketIOManager.sharedInstance.establishConnection()
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            // For iOS 10 data message (sent via FCM
//            Messaging.messaging().delegate = self
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        SocketIOManager.sharedInstance.closeConnection()
        SocketIOManager.sharedInstance.establishConnection()
//        do {
//            
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategory.init() as String, mode: AVAudioSessionMode.init() as String , options: [.mixWithOthers, .allowAirPlay])
//            SocketIOManager.sharedInstance.establishConnection()
//            print("Playback OK")
//            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
//        } catch {
//            print(error)
//        }
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        SocketIOManager.sharedInstance.establishConnection()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        _ = InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error is \(error)")
            }
            else if let result = result {
                print("Result is \(result.token)")
                Requests.fcmToken = result.token
                
            }
        })
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        let manager = SocketManager(socketURL: URL(string: "http://5.63.112.4:43000")!)
//        let socket = manager.defaultSocket
//        socket.connect()
//        socket.on("connect") { _, _ in
//            print("socket connected")
//            let dic = Locksmith.loadDataForUserAccount(userAccount: "energyStreamToken")
//            let token = dic?["token"] as? String ?? ""
//            socket.emit("auth", ["token":token])
//        }
//
//        socket.on("disconnect") { _, _ in
//            print("socket disconnected")
//        }
//
//        socket.on("notifications") { dataArray, ack in
//            guard let data = dataArray[0] as? [String:Any] else {return}
//            SocketIOManager.sharedInstance.pushNotification(message:data)
//
//        }
//
//    }

}

