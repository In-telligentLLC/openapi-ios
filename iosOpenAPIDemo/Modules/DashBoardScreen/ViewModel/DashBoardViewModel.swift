//
//  DashBoardViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 13/12/22.
//

import Foundation
import OpenAPI
import CoreLocation

/// this class is responsible for storing the logic behind displaying list of communities in dash board screen
class DashBoardViewModel : NSObject {
    
    // MARK: Variables declaration
    
    /// appDelegate: an instance of AppDelegate
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /// subscribedCommunities : an array of type INCommunity which stores list of subscribed communities
    var subscribedCommunities : [INCommunity] = []
    
    /// allNotifications: an array of type INNotification
    var allNotifications: [INNotification] = []
    
    /// alertsFetchCompletion: a variable which provides a return type Void
    var alertsFetchCompletion: (() -> Void)?
    
    /// areLocationPermissionsAllowed: a boolean type variable
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
    
    // MARK: Initialization
    
    /// fetches all subscribed communities
    override init() {
        super.init()
        self.subscribedCommunities = INCommunityManager.shared.getCommunities()
    }
    
    // MARK: Static methods
    
    /// shows settings alert when user permissions are denied for the respective type
    /// - Parameters:
    ///   - type: a string value based on which alert will be displayed
    ///   - viewcontroller: the viewcontroller where the alert feature need to be implemented
    func showSettingsALert(type: String, viewcontroller: DashBoardViewController) {
        viewcontroller.showSettingsAlert(type: type)
    }
    
    /// checks whether notification permissions are allowed or not
    /// - Parameter viewController: viewcontroller where the checking of notification permissions should be implemented
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
    
    /// checks whether location permissions are allowed or not
    /// - Parameters:
    ///   - called: a string value "didUpdateLocationStatus"
    ///   - viewController: viewcontroller where the checking of location permissions should be implemented
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
