//
//  ViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 07/01/23.
//

import UIKit
import OpenAPI
import Localize

/// handles lauching various screens 
extension UIViewController {
    
    //MARK: Static methods 
    /// navigates to alert list screen
    /// - Parameter community: an optional value which contains all the details of a particular community tapped
    func goToAlertList(with community : INCommunity?) {
        guard let viewController = Storyboard.main.viewController(AlertListViewController.self) else { return }
        viewController.viewModel = AlertListViewModel(community, filter: .building)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// navigates to alert detail screen
    /// - Parameters:
    ///   - community: an optional value which contains all the details of a particular community tapped
    ///   - notification: an optional value which which contains details of notification
    func gotoAlertDetail(with community: INCommunity?, and notification: INNotification?) {
        guard let alertDetailController = Storyboard.main.viewController(AlertDetailViewController.self) else {
            return
        }
        alertDetailController.viewModel = AlertDetailViewModel(notification: notification, community: community)
        self.navigationController?.pushViewController(alertDetailController, animated: true)
    }
    
    /// displays a loader on screen
    func showLoader(_ completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: "Please wait...".localized, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: completion)
    }
    
    /// dismisses loader on screen
    func hideLoader(completion: (() -> Void)? = nil) {
        if self.presentedViewController is UIAlertController {
            if self.presentedViewController?.tabBarItem.title == nil || self.presentedViewController?.tabBarItem.title == "App Permission Denied" {
                dismiss(animated: true, completion: completion) }
        }
    }
}
