//
//  StoryBoard.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 07/01/23.
//

import UIKit

// declaration of enum 
enum Storyboard : String {
    case onboarding = "Onboarding",
         main = "Main",
         alerts = "Alerts",
         community = "Community",
         maps = "Maps",
         settings = "Settings"
    
    // Variables declaration 
    var storyboard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController>(_ viewController: T.Type) -> T? {
        return storyboard.instantiateViewController(withIdentifier: viewController.className) as? T
    }
    
}
