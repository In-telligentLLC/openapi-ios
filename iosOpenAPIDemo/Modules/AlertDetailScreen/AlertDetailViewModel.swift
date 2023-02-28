//
//  AlertDetailViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 09/01/23.
//

import Foundation
import OpenAPI

/// this class is responsible for storing the logic behind alert details
class AlertDetailViewModel : NSObject {
    
    //MARK: Variables declaration
    
    ///community : instance of INCommunity
    var community: INCommunity?
    
    ///notification: instance of INNotification
    var notification: INNotification?
    
    // MARK: Initialization
    
    /// calling init methods from super class
    override init() {
        super.init()
    }
    
    /// initializing and getting all the communities into community parameter and the notifications into notification parameter
    /// - Parameters:
    ///   - notification: an optional value which contains all the details of notifications
    ///   - community: an optional value which contains all the details of communities
    init(notification: INNotification?, community: INCommunity?) {
        self.community = community
        if community == nil {
            self.community = OpenAPI.getCommunity(by: notification?.buildingId ?? 0)
        }
        self.notification = notification
    }
}
