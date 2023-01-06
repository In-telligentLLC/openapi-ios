//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Likhitha  Narayana on 06/01/23.
//

import UserNotifications
import OpenAPI

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.title = "Modified Title"
            bestAttemptContent.body = "Modified Body"
            if let notificationID = ((bestAttemptContent.userInfo["notification"] as? [String: Any])?["id"] as? String) {
                self.markDelivered(with: notificationID)
                contentHandler(bestAttemptContent)
            } else {
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    func markDelivered(with notificationId: String) {
        API.markDelivered(notificationId, success: {
        }, failure: { _,_  in
        })
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
