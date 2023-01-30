//
//  DashBoardViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 13/12/22.
//

import Foundation
import OpenAPI
import CoreLocation

class DashBoardViewModel : NSObject {
    
    // Variables declaration
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var subscribedCommunities : [INCommunity] = []
    var allNotifications: [INNotification] = []
    var alertsFetchCompletion: (() -> Void)?
    var areLocationPermissionsAllowed : Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            return true
        @unknown default:
            break
        }
        return true
    }
    
    override init() {
        super.init()
        /// fetches all subscribed communities
        self.subscribedCommunities = OpenAPI.getCommunities()
    }
    
    /// shows settings alert when user permissions are denied for the resepctive type
    func showSettingsALert(type: String, viewcontroller: DashBoardViewController) {
        viewcontroller.showSettingsAlert(type: type)
    }
    
    /// checks whether notification permissions are allowed or not , if they are not allowed a settings alert of type notifications will be displayed on the screen where user can navigate to settings and allow permissions
    func checkForNotificationPermissions(viewController: DashBoardViewController) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.appDelegate.registerForRemoteNotifications()
            case .denied:
                DispatchQueue.main.async {
                    viewController.showSettingsAlert(type: "Notifications")
                }
                break
            case .authorized:
                self.appDelegate.registerForRemoteNotifications()
                break
            default:
                break
            }
        })
    }
    
    /// checks whether location permissions are allowed or not , if they are not allowed a settings alert of type locations will be displayed on the screen where user can navigate to settings and allow permissions
    func checkPermissions(called:String, viewController: DashBoardViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            if !self.areLocationPermissionsAllowed {
                if OpenAPI.doesClientRequiresLocationPermissions {
                    viewController.showSettingsAlert(type: "Locations")
                }
            }
        }
        if !INPushManager.shared.havePushTokens() {
            viewController.showSettingsAlert(type: "Notifications")
        }
    }
    
    /// fetches all saved notifications of all communities
    func fetchNotifications() {
        self.allNotifications = INNotification.getSavedNotificaitons()
        self.alertsFetchCompletion?()
    }
}
