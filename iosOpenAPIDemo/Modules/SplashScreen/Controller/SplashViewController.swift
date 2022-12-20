//
//  SplashViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 01/12/22.
//

import UIKit
import OpenAPI

class SplashViewController: UIViewController {
    
    var window : UIWindow?
    
    ///  loading the view and checking whether user is already registered or not , if the user is a registered user navigate directly to dashboard activity else navigate to login activity.
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // if user is a registered user move to dash board activity.
       // OpenAPI.configure(to: .dev, partnerToken: PartnerToken.getPartnerToken())
        if (OpenAPI.checkToken()) {
            if let controller = storyboard.instantiateViewController(withIdentifier: "DashBoardViewController") as? DashBoardViewController {
                self.window!.rootViewController = UINavigationController(rootViewController: controller)
            }
        }
        
        // if user is not a registered user move to login activity. 
        else {
            if let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                self.window!.rootViewController = UINavigationController(rootViewController: controller)
            }
        }
        self.window?.makeKeyAndVisible()
    }
}



