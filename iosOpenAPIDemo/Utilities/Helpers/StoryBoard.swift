//
//  StoryBoard.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 07/01/23.
//

import UIKit

///  handles screen names 
enum Storyboard : String {
    /// onboarding screen
    case onboarding = "Onboarding",
         /// main screen
         main = "Main",
         /// alerts screen
         alerts = "Alerts",
         /// community screen
         community = "Community",
         /// maps screen
         maps = "Maps",
         /// settings screen
         settings = "Settings"
    
    //MARK: Variables declaration
    /// storyboard : an instance of UIStoryboard
    var storyboard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    // MARK: Static methods
    
    /// gives a view controller to be launched
    /// - Parameter viewController: an instance of UIViewController
    /// - Returns: a view controller to be launched
    func viewController<T: UIViewController>(_ viewController: T.Type) -> T? {
        return storyboard.instantiateViewController(withIdentifier: viewController.className) as? T
    }
    
}
