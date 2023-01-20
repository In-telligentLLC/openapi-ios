//
//  AlertListViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 07/01/23.
//

import UIKit
import OpenAPI
import RealmSwift

enum AlertFilter {
    case all, normal, emergency, suggested, building
}

class AlertListViewModel: NSObject {
    
    var community: INCommunity!
    var groupedNotifications: [(key: Date, value: [INNotification])] = []
    var filter: AlertFilter = .all
    
    var notifications: [INNotification] = [] {
        didSet {
            self.groupedNotifications = Dictionary(grouping: self.notifications) {
                $0.startDate?.formattedDate(from: "dd MMM yyyy") ?? Date()
            }.sorted(by: { $0.key > $1.key })
        }
    }
    
    override init() {
        super.init()
    }
    
    init(_ community: INCommunity?, filter: AlertFilter) {
        super.init()
        self.community = community
        self.filter = filter
    }
    
    func updateNotificationsByCommunity() {
        self.notifications = OpenAPI.getNotificationsByBuilding(self.community?.id ?? 0).reversed()
    }
}
