//
//  DashBoardViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 13/12/22.
//

import Foundation
import OpenAPI

class DashBoardViewModel : NSObject {
    
    var allCommunities: [INCommunity] = []
    var communitiesFetchCompletion: ((String?) -> Void)?
    
    override init() {
        super.init()
        
        let communities = OpenAPI.getSubscribedCommunities()
        self.allCommunities = Array(communities)
    }
    
    func getCommunities() {
        self.allCommunities = OpenAPI.getCommunities()
        communitiesFetchCompletion?(nil)
    }
    
    
}

extension DashBoardViewModel: INSubscriberManagerDelegate {
    
    func subscribedCommunities(_ subscribedCommunities: [INCommunity]) {
        self.allCommunities = subscribedCommunities
        communitiesFetchCompletion?(nil)
        // self.fetchNotifications()
    }
    
    @objc func subscriptionProcessDidComplete(_ notification: Foundation.Notification) {
        self.allCommunities = INCommunityManager.shared.getSubscribedCommunities()
        //   self.fetchNotifications()
        communitiesFetchCompletion?(nil)
    }
}

