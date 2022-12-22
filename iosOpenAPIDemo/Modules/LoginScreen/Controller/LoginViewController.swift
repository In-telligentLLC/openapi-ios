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
    
    // creating an instance of CLLocationManager.
    let locationManager = CLLocationManager()
    
    // IBoutlet for signup button.
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //IBAction to perform when sign-in button is tapped
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
                self.showAlertWithMessage("Fill required fields or something went wrong, please try again.")
            }
        }
    }
    
    func showAlertWithMessage(_ message: String) {
        // create the alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue : CLLocationCoordinate2D = manager.location?.coordinate else { return }
    }
    
}
