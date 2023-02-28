//
//  SerachCommunitiesViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 18/01/23.
//

import UIKit
import OpenAPI

/// this class is responsible for storing logic behind searching communities
class searchCommunitiesViewModel : NSObject {
    
    // MARK: Variables declaration
    /// searchCommunities : an array of type INCommunity
    var searchCommunities : [INCommunity] = []
    
    // MARK: Initialization
    /// gets all the communites 
    override init() {
        super.init()
        /// getting all the subscribed and unsubscribed communities
        self.searchCommunities = OpenAPI.getCommunities()
    }
}
