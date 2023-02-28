//
//  AlertListViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 07/01/23.
//

import UIKit
import OpenAPI
import RealmSwift

// MARK: Declaring an enum
/// this enum handles all the cases of alert
enum AlertFilter {
        /// all alerts
    case all,
         /// normal alert
         normal,
         /// emergency alert
         emergency,
         /// suggested alert
         suggested,
         /// building id 
         building
}

/// this class is responsible for handling the logic behind alert list
class AlertListViewModel: NSObject {
    
    //MARK: variables declaration
    
    /// community: instance of INCommunity
    var community: INCommunity!
    
    /// groupedNotifications:  variable of type array
    var groupedNotifications: [(key: Date, value: [INNotification])] = []
    
    /// filter : instance of AlertFilter enum with .all case
    var filter: AlertFilter = .all
    
    /// notifications : array of type INNotification
    var notifications: [INNotification] = [] {
        didSet {
            self.groupedNotifications = Dictionary(grouping: self.notifications) {
                $0.startDate?.formattedDate(from: "dd MMM yyyy") ?? Date()
            }.sorted(by: { $0.key > $1.key })
        }
    }
    
    // MARK: Initialization
    
    /// calling init methods from super class
    override init() {
        super.init()
    }
    
    
    /// initializing and getting all the alerts based on community
    /// - Parameters:
    ///   - community: an instance of INCommunity
    ///   - filter:  an instance of AlertFilter enum with .all case
    init(_ community: INCommunity?, filter: AlertFilter) {
        super.init()
        self.community = community
        self.filter = filter
    }
    
    //MARK: Static methods 
    /// fetches all notifications based on community id
    func updateNotificationsByCommunity() {
        self.notifications = OpenAPI.getNotificationsByBuilding(self.community?.id ?? 0).reversed()
    }
}
