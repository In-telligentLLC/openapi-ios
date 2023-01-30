//
//  AlertListViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit
import OpenAPI

class AlertListViewController: UIViewController {
    
    // MARK: IBOutlet for AlertListTableView
    @IBOutlet var AlertListTableView: UITableView!
    
    // Variables declaration
    var viewModel = AlertListViewModel()
    
    // MARK: View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AlertListTableView.delegate = self
        self.AlertListTableView.dataSource = self
        self.AlertListTableView.register(UINib(nibName: "AlertListTableViewCell", bundle: .main) , forCellReuseIdentifier: "AlertListTableViewCell")
        self.viewModel.updateNotificationsByCommunity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Alert List"
    }
}
// MARK: tableView delegate, data source methods
extension AlertListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.notifications.count == 0 {
            self.AlertListTableView.setMessage("No alerts at this moment")
        }
        /// returning count of notifications of a particular community
        return self.viewModel.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AlertListTableView.dequeueReusableCell(withIdentifier: "AlertListTableViewCell", for: indexPath) as! AlertListTableViewCell
        /// displaying data of  notification
        cell.notification = self.viewModel.notifications[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// navigating to alert details screen when a notification is tapped
        self.gotoAlertDetail(with: self.viewModel.community, and: self.viewModel.groupedNotifications[indexPath.section].value[indexPath.row])
    }
}
