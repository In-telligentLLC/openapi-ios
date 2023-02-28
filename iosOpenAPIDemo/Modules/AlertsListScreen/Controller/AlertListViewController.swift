//
//  AlertListViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit
import OpenAPI

/// this class is responsible for displaying  list of alerts
class AlertListViewController: UIViewController {
    
    // MARK: IBOutlet variables
    /// AlertListTableView : table view which displays a list of alerts of a particular community
    @IBOutlet var AlertListTableView: UITableView!
    
    // MARK: Variables declaration
    /// viewModel : instance of AlertListViewModel class
    var viewModel = AlertListViewModel()
    
    // MARK: View life cycle methods
    /// loads a list of alerts of particular community
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AlertListTableView.delegate = self
        self.AlertListTableView.dataSource = self
        self.AlertListTableView.register(UINib(nibName: "AlertListTableViewCell", bundle: .main) , forCellReuseIdentifier: "AlertListTableViewCell")
        self.viewModel.updateNotificationsByCommunity()
    }
    
    /// sets title of screen as Alert List
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Alert List"
    }
}
// MARK: extension for UITableViewDelegate, UITableViewDataSource
/// this extension is responsible for handling AlertListTableView
extension AlertListViewController : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDelegate, UITableViewDataSource delegate methods
    
    ///  gives count of notifications
    /// - Parameters:
    ///   - tableView: AlertListTableView
    ///   - section: section in a table view
    /// - Returns: count of notifications
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.notifications.count == 0 {
            self.AlertListTableView.setMessage("No alerts at this moment")
        }
        /// returning count of notifications of a particular community
        return self.viewModel.notifications.count
    }
    
    
    /// gives content of alert to cell
    /// - Parameters:
    ///   - tableView: AlertListTableView
    ///   - indexPath: the index path locating the row in the table view.
    /// - Returns: content of alert to cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AlertListTableView.dequeueReusableCell(withIdentifier: "AlertListTableViewCell", for: indexPath) as! AlertListTableViewCell
        /// displaying data of  notification
        cell.notification = self.viewModel.notifications[indexPath.row]
        return cell
    }
    
    /// gives height to cell of table view
    /// - Parameters:
    ///   - tableView: AlertListTableView
    ///   - indexPath: the index path locating the row in the table view.
    /// - Returns:  height to cell of table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    /// navigates to alert detail screen when an alert is tapped
    /// - Parameters:
    ///   - tableView: AlertListTableView
    ///   - indexPath: the index path locating the row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// navigating to alert details screen when a notification is tapped
        self.gotoAlertDetail(with: self.viewModel.community, and: self.viewModel.groupedNotifications[indexPath.section].value[indexPath.row])
    }
}
