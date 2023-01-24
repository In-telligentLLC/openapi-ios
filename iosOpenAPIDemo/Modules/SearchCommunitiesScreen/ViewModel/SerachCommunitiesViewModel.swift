//
//  SerachCommunitiesViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 18/01/23.
//

import UIKit
import OpenAPI

class searchCommunitiesViewModel : NSObject {
    
    var searchCommunities : [INCommunity] = []
    
    override init() {
        super.init()
        self.searchCommunities = OpenAPI.getAllCommunities()
    }
}
