//
//  SerachCommunitiesViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 18/01/23.
//

import UIKit
import OpenAPI

class searchCommunitiesViewModel : NSObject {
    
    // Variables declaration
    var searchCommunities : [INCommunity] = []
    
    override init() {
        super.init()
        /// getting all the subscribed and unsubscribed communities
        self.searchCommunities = OpenAPI.getAllCommunities()
    }
}
