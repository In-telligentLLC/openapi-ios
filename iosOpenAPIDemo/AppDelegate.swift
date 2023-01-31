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
    
    /// configuring OpenAPI by choosing uat environment, to operate it .
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerForRemoteNotifications()
        OpenAPI.configure(to: .uat, partnerToken: PartnerToken.getPartnerToken(), currentSandboxType: .prod)
        print("current partner token = \(PartnerToken.getPartnerToken())")
        window = UIWindow(frame: UIScreen.main.bounds)
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

// MARK: "UNUserNotificationCenterDelegate" protocol methods handles user selected actions from notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    
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
        self.goToAlertDetails(dictionary:userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        OpenAPI.didReceiveResponseFromUserNotificationCenter(response)
        OpenAPI.saveFromNotificationCenter([response.notification])
        self.goToAlertDetails(dictionary: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    /// launching alert details screen after tapping a notification
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
            guard let notficationID = notification?.buildingId else {return}
            let community = OpenAPI.getCommunitiesInfo(by: notficationID)
            dashBoardController.gotoAlertDetail(with: community, and: notification)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        OpenAPI.saveFromNotificationCenter([notification])
        completionHandler([.alert,.sound,.badge])
    }
    private func saveNotificationsToDatabase() {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            if !notifications.isEmpty {
                OpenAPI.saveFromNotificationCenter(notifications)
            }
        }
    }
}
