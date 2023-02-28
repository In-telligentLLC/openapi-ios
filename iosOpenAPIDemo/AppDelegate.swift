//
//  AppDelegate.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 01/12/22.
//

import UIKit
import OpenAPI

/// this class is responsible for handling various behaviours of application
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: Variables declaration
    /// window: an instance of UIWindow
    var window: UIWindow?
    
    //MARK: Delegate methods
    /// called after app is launched ,it configures OpenAPI by choosing uat environment to operate it .
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched
    /// - Returns: true if configuring openAPI is done and gets partner token
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerForRemoteNotifications()
        OpenAPI.configure(to: .uat, partnerToken: PartnerToken.getPartnerToken(), currentSandboxType: .dev)
        print("current partner token = \(PartnerToken.getPartnerToken())")
        window = UIWindow(frame: UIScreen.main.bounds)
        return true
    }
    
    /// app is about to leave the active state
    /// - Parameter application: The singleton app object.
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    /// app went to background successfully
    /// - Parameter application: The singleton app object.
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    /// app about to enter foreground
    /// - Parameter application: The singleton app object.
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    ///  when app becomes active retirves all the notifications
    /// - Parameter application: The singleton app object.
    func applicationDidBecomeActive(_ application: UIApplication) {
        saveNotificationsToDatabase()
    }
    
    /// app is  about to terminate
    /// - Parameter application: The singleton app object.
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// registers for remote notifications and stores device token
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - deviceToken: a unique value for every device
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        INPushManager.regularPushToken = deviceTokenString
        print("APN's Device Token \(deviceTokenString)")
    }
    
    /// displays the error when registration fails
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - error: description of error which is occured
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    ///  after receiving notification when user taps on it , moves to alert detail screen
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - userInfo: A dictionary that contains information related to the remote notification
    ///   - completionHandler: The block to execute when you have finished processing the user’s response
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        OpenAPI.relayPushKitNotification(dictionaryPayload: userInfo)
        self.goToAlertDetails(dictionary:userInfo)
    }
    
    /// when notifications is received and tapped user moves to alert details screen
    /// - Parameters:
    ///   - center: The shared user notification center object that received the notification.
    ///   - response: response received from user to the notification
    ///   - completionHandler: The block to execute when you have finished processing the user’s response
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        OpenAPI.didReceiveResponseFromUserNotificationCenter(response)
        OpenAPI.saveFromNotificationCenter([response.notification])
        self.goToAlertDetails(dictionary: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    
    /// an instance method which handles a notification that arrived while the app was running in the foreground.
    /// - Parameters:
    ///   - center: The shared user notification center object that received the notification.
    ///   - notification: The singleton app object.
    ///   - completionHandler: The block to execute when you have finished processing the user’s response
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        OpenAPI.saveFromNotificationCenter([notification])
        completionHandler([.alert,.sound,.badge])
    }
    
    //MARK: Static methods
    /// registering for remote notification permissions
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
    
    /// launching alert details screen after tapping a notification
    /// - Parameter dictionary: a provided dictionary value
    func goToAlertDetails(dictionary: [AnyHashable: Any]) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if let dashBoardController = (window?.rootViewController?.children.last as? UINavigationController)?.topViewController as? DashBoardViewController {
            dashBoardController.isNotificationReceived = true
            if dashBoardController.revealViewController().frontViewPosition != FrontViewPosition.left {
                dashBoardController.isFromDashboard = true
            }
            dashBoardController.viewModel.fetchNotifications()
            dashBoardController.viewWillAppear(true)
            let notification = INNotification(dictionary: dictionary)
            guard let notificationID = notification?.buildingId else {return}
            let community = OpenAPI.getCommunity(by: notificationID)
            dashBoardController.gotoAlertDetail(with: community, and: notification)
        }
    }
    
    ///  stores all the notifications to local data base
    private func saveNotificationsToDatabase() {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            if !notifications.isEmpty {
                OpenAPI.saveFromNotificationCenter(notifications)
            }
        }
    }
}
