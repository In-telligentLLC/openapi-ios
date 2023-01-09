//
//  ViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 07/01/23.
//

import UIKit
import OpenAPI

extension UIViewController {
    
    func goToAlertList(with community : INCommunity?) {
        guard let viewController = Storyboard.main.viewController(AlertListViewController.self) else { return }
        viewController.viewModel = AlertListViewModel(community, filter: .building)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotoAlertDetail(with community: INCommunity?, and notification: INNotification?) {
        guard let alertDetailController = Storyboard.main.viewController(AlertDetailViewController.self) else {
            return
        }
        alertDetailController.viewModel = AlertDetailViewModel(notification: notification, community: community)
        self.navigationController?.pushViewController(alertDetailController, animated: true)
    }
}
