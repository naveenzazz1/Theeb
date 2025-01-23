//
//  PushNotificationManager.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 16/01/1444 AH.
//

import Foundation
import FirebaseMessaging
import Firebase


class PushNotificationManager:NSObject  {
    
     
     // MARK: - Singleton
     
     static let manager = PushNotificationManager()
     
    

     // MARK: - Variables
     
     
     var fcmToken: String? {
         
         return Messaging.messaging().fcmToken
        
     }
     
     
    var currentFcmToken: String? {
        
        return CachingManager.getValue(forKey: CachingKeys.NotificationsDeviceToken) as? String
    }
    
    
     // MARK: - Configuration
     
     func configure() {
         
         FirebaseApp.configure()
     }
     
 
     // MARK: - Badge Icon
     
     func setApplicationIconBadgeNumber(_ number: Int) {
         
         UIApplication.shared.applicationIconBadgeNumber = number
     }
     
     func resetBadge() {
         
         setApplicationIconBadgeNumber(0)
     }

     // MARK: - Register Push Notification
     
     func registerForRemoteNotifications(_ application: UIApplication) {

       UNUserNotificationCenter.current().delegate = self
         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
         UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                guard granted else { return }
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            })
         
         Messaging.messaging().delegate = self
     }
    
    // MARK: - Caching
    
    func storeDeviceTokenInCache(_ token: String?) {
        
        CachingManager.store(value: token, forKey: CachingKeys.NotificationsDeviceToken)
      
    }
    
    func storeNotification(_ notification: UNNotification) {
        
        var notifications = CachingManager.notifications() ?? [UNNotification]()
        notifications.append(notification)
        CachingManager.setNotifications(notifications)
    }
    
    func registerToken(fcmToken:String){
        PushNotificationService.instance.getPushNotificationAccesToken { success, token in
            if success , let token = token{
                PushNotificationService.instance.updatecFcmToken(accessToken: token, fcmToken: fcmToken) { status in
                   // if status == "Success" {
                    self.updateToken(newToken: fcmToken)
                   // }
                }
            }
        }
    }
    
    func storeNotificationTitleAndBody(title:String?, body:String?) {
        guard let title = title, let body = body else {return}
        var notificationArr = CachingManager.notificationsTitleAndBody ?? [Messages]()
        let notificationDetails = Messages(title: title, body: body, date: nil)
        if !notificationArr.contains(where: { $0 == notificationDetails}) {
            notificationArr.append(notificationDetails)
            CachingManager.notificationsTitleAndBody = notificationArr
        }
    }
    
    func registerUserDeviceToken(_ fcmToken: String? = Messaging.messaging().fcmToken, referenceId: Int? = nil) {
        guard let fcmToken = fcmToken else { return }
        if let registeredToken = currentFcmToken {
            if registeredToken != fcmToken {
                registerToken(fcmToken:fcmToken)
            }
        } else {
            if CachingManager.loginObject() != nil{
                registerToken(fcmToken:fcmToken)
            }
        }
    }

    
     
    func updateToken(newToken: String){
        CachingManager.removeValue(forKey: CachingKeys.NotificationsDeviceToken)
        storeDeviceTokenInCache(newToken)
    }

    
}

// MARK: - MessagingDelegate

extension PushNotificationManager: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken = ",fcmToken ?? "")
        registerUserDeviceToken(fcmToken)
//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//        NotificationCenter.default.post(
//          name: Notification.Name("FCMToken"),
//          object: nil,
//          userInfo: dataDict
//        )
    }
}


// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationManager: UNUserNotificationCenterDelegate {
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        Messaging.messaging().apnsToken = deviceToken as Data
     
        print("InstanceID token: \(deviceToken)")
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//     //   resetBadge()
//     //     storeNotification(notification)
//        
//        //this func called when user tap on the notification in background
//        let notificationTitle = response.notification.request.content.title
//        let notificationBody = response.notification.request.content.body
//        storeNotificationTitleAndBody(title: notificationTitle, body: notificationBody)
//
//    }
  
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        //this func called when user recive the notification in forground
//        let userInfo = notification.request.content.userInfo
//        let aps = userInfo["aps"] as? [String: Any]
//        let alert = aps?["alert"] as? [String: String]
//        let title = alert?["title"]
//        let body = alert?["body"]
//        storeNotificationTitleAndBody(title: title, body: body)
//        completionHandler([.list, .banner, .badge])
//    }
}


