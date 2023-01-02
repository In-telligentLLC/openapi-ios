//
//  DashBoardViewModel.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 13/12/22.
//

import Foundation
import OpenAPI
import CoreLocation

class DashBoardViewModel : NSObject {
    
    override init() {
        super.init()
    }
    var areLocationPermissionsAllowed : Bool {
           switch CLLocationManager.authorizationStatus() {
           case .authorizedAlways, .authorizedWhenInUse:
               return true
           case .denied, .restricted:
               return false
           case .notDetermined:
               return true
           @unknown default:
               break
           }
           return true
       }
}



