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

class LoginViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    // MARK: IBoutlet for signup button.
    @IBOutlet var signUpButton: UIButton!
    
    // MARK: View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBAction to perform when sign-in button is tapped
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
    
    /// display an alert with a particular message
    func showAlertWithMessage(_ message: String) {
        /// create the alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        /// add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        /// show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
