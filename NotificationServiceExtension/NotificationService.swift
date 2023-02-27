//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Likhitha  Narayana on 06/01/23.
//

import UserNotifications
import OpenAPI

class NotificationService: UNNotificationServiceExtension {
    
    //MARK: Variables declaration
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    /// use this method to make any changes in notification content within limited amount of time
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        OpenAPI.setEnvironment(to: .uat)
        if let bestAttemptContent = bestAttemptContent {
            if let notificationID = ((bestAttemptContent.userInfo["notification"] as? [String: Any])?["id"] as? String) {
                print(notificationID)
                self.markDelivered(with: notificationID)
                contentHandler(bestAttemptContent)
            } else {
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    /// updates the server whether the notification is delivered to user or not
    func markDelivered(with notificationId: String) {
        API.markDelivered(notificationId, success: {
        }, failure: { _,_  in
        })
    }
    
    /// this method will be called to give user one last chance to submit changes in content within given period
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
