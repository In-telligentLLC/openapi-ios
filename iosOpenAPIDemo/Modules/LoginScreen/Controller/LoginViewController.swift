//
//  LoginViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit
import OpenAPI
import CoreLocation
import SVProgressHUD

/// this class is responsible for user registration
class LoginViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    // MARK: IBOutlet variables
    
    /// signUpButton: a button to sign-up user
    @IBOutlet var signUpButton: UIButton!
    
    // MARK: View life cycle methods
    
    ///called whenever view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBAction method
    
    /// if authorization is successfull enters into Dash Board screen else shows an alert
    /// - Parameter sender:  tells who caused the action on button
    @IBAction func LoginWithDetails(_ sender: Any) {
        SVProgressHUD.show()
        OpenAPI.authorization() { error, status in
            if status {
                let scene = UIApplication.shared.connectedScenes.first
                if let window : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
                    window.window?.rootViewController = controller
                    DispatchQueue.main.async { SVProgressHUD.dismiss() }
                }
            } else {
                self.showAlertWithMessage("Something went wrong, please try again.")
            }
        }
    }
    
    //MARK: Static methods 
    
    /// display an alert with a particular message
    /// - Parameter message: a string value which will be displayed on the screen as an alert message
    func showAlertWithMessage(_ message: String) {
        /// create the alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        /// add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        /// show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
