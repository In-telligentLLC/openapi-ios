//
//  DashBoardViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 01/12/22.
//

import UIKit
import OpenAPI
import PushKit
import UserNotifications
import AVFoundation
import SwiftyJSON

class DashBoardViewController: UIViewController {
    
    // Variables declaration
    @IBOutlet var sideMenuButton: UIBarButtonItem!
    @IBOutlet var CommunityTableView: UITableView!
    var revealView: SWRevealViewController! = nil
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel = DashBoardViewModel()
    var notification: INNotification?
    var isNotificationReceived = false
    var isFromDashboard = false
    
    //MARK: View life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CommunityTableView.delegate = self
        self.CommunityTableView.dataSource = self
        
        revealView = self.revealViewController()
        sideMenuButton.target = revealView
        sideMenuButton.action = #selector(revealView?.revealToggle(_:))
        sideMenuButton.tintColor = .white
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        OpenAPI.start(self)
        
        self.CommunityTableView.register(UINib(nibName: "DashBoardCommunitiesTableViewCell", bundle: .main), forCellReuseIdentifier: "DashBoardCommunitiesTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSubscribeToCommunities(notification:)), name: .subscriptionProcessDidComplete, object: nil)
        
        self.viewModel.checkForNotificationPermissions(viewController: self)
        INGeofencer.shared.didUpdateLocationStatus = { _ in
            self.viewModel.checkPermissions(called: "didUpdateLocationStatus" , viewController: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Communities List"
        self.navigationController?.navigationItem.titleView?.tintColor = .white
        if isFromDashboard {
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isFromDashboard = false
    }
    
    @objc func didSubscribeToCommunities(notification: Notification) {
        DispatchQueue.main.async {
            self.CommunityTableView.reloadData()
        }
    }
}
//MARK: tableView Delegate,DataSource Methods
extension DashBoardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.subscribedCommunities.count == 0 {
            CommunityTableView.setMessage("No communities found at this moment")
        } else {
            CommunityTableView.clearBackground()
        }
        return self.viewModel.subscribedCommunities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommunityTableView.dequeueReusableCell(withIdentifier: "DashBoardCommunitiesTableViewCell", for: indexPath) as! DashBoardCommunitiesTableViewCell
        let community = self.viewModel.subscribedCommunities[indexPath.row]
        cell.CommunityCellLabel.text = community.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToAlertList(with : self.viewModel.subscribedCommunities[indexPath.row])
    }
}

extension DashBoardViewController: INSubscriberManagerDelegate {
    
    func subscribedCommunities(_ subscribedCommunities: [INCommunity]) {
        self.viewModel.subscribedCommunities = OpenAPI.getSubscribedCommunities()
        DispatchQueue.main.async {
            self.CommunityTableView.reloadData()
        }
    }
}
