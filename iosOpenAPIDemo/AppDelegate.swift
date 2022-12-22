//
//  AppDelegate.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 01/12/22.
//

import UIKit
import OpenAPI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.registerForRemoteNotifications()
        
        OpenAPI.configure(to: .dev, partnerToken: PartnerToken.getPartnerToken(), currentSandboxType: .dev)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        /// it is about to leave the active state
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        /// went to background successfully
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // about to enter foreground
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        saveNotificationsToDatabase()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // abouut to terminate
    }
}


extension AppDelegate {
    
    static var isUserLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "is_user_loggedIn") }
        set {
            UserDefaults.standard.set(newValue, forKey: "is_user_loggedIn")
            UserDefaults.standard.synchronize()
        }
    }
}

extension AppDelegate {
    
    static func havePushTokens() -> Bool {
        if INPushManager.voipPushToken != "" && INPushManager.regularPushToken != "" {
            return true
        }
        return false
    }
    
    static var isPushRegistered: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "is_push_registered")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "is_push_registered")
            UserDefaults.standard.synchronize()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // registering for remote notification permissions
    func registerForRemoteNotifications() {
        INPushManager.shared.requestForNotificationPermission { (_) in
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        INPushManager.regularPushToken = deviceTokenString
        print("APN's Device Token \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        OpenAPI.relayPushKitNotification(dictionaryPayload: userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.trigger is UNPushNotificationTrigger {
            OpenAPI.relayPushKitNotification(dictionaryPayload: response.notification.request.content.userInfo)
        } else {
            NotificationCenter.default.post(name: Foundation.Notification.Name.receivedPushNotification, object: nil, userInfo: response.notification.request.content.userInfo)
        }
    }
    
    private func saveNotificationsToDatabase() {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            if !notifications.isEmpty {
                OpenAPI.saveFromNotificationCenter(notifications)
            }
        }
    }
}
