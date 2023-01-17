//
//  AlertListViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit
import OpenAPI

class AlertListViewController: UIViewController {
    
    @IBOutlet var AlertListTableView: UITableView!
    
    var viewModel = AlertListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AlertListTableView.delegate = self
        self.AlertListTableView.dataSource = self
        self.AlertListTableView.register(UINib(nibName: "AlertListTableViewCell", bundle: .main) , forCellReuseIdentifier: "AlertListTableViewCell")
        self.title = "Alert List"
        self.navigationItem.backButtonTitle = "Back"
        self.viewModel.updateNotificationsByCommunity()
    }
}

extension AlertListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.notifications.count == 0 {
            self.AlertListTableView.setMessage("No alerts at this moment")
        }
        return self.viewModel.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AlertListTableView.dequeueReusableCell(withIdentifier: "AlertListTableViewCell", for: indexPath) as! AlertListTableViewCell
        cell.notification = self.viewModel.notifications[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gotoAlertDetail(with: self.viewModel.community, and: self.viewModel.groupedNotifications[indexPath.section].value[indexPath.row])
    }
}
