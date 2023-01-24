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
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var subscribedCommunities : [INCommunity] = []
    var allNotifications: [INNotification] = []
    var alertsFetchCompletion: (() -> Void)?
    
    override init() {
        super.init()
        self.subscribedCommunities = OpenAPI.getCommunities()
    }
    
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
    
    func showSettingsALert(type: String, viewcontroller: DashBoardViewController) {
        viewcontroller.showSettingsAlert(type: type)
    }
    
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
    
    func fetchNotifications() {
        self.allNotifications = INNotification.getSavedNotificaitons()
        self.alertsFetchCompletion?()
    }
}
