//
//  AlertDetailViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 09/01/23.
//

import Foundation
import OpenAPI

class AlertDetailViewModel : NSObject {
    
    var community: INCommunity?
    var notification: INNotification?
    
    override init() {
        super.init()
    }
    
    init(notification: INNotification?, community: INCommunity?) {
        self.community = community
        if community == nil {
            self.community = INCommunityManager.shared.getCommunity(by: notification?.buildingId ?? 0)
        }
        self.notification = notification
    }
}
