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

/// this class is responsible for displaying a list of communites on dash board screen
class DashBoardViewController: UIViewController {
    
    // MARK: IBOutlet variables
    
    /// sideMenuButton: bar button to open side menu
    @IBOutlet var sideMenuButton: UIBarButtonItem!
    
    /// CommunityTableView: table view which shows a list of communities
    @IBOutlet var CommunityTableView: UITableView!
    
    //MARK: variables declaration

    /// revealView : an instance of SWRevealViewController
    var revealView: SWRevealViewController! = nil
    
    /// appDelegate: an instance of AppDelegate
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /// viewModel: an instance of DashBoardViewModel class
    var viewModel = DashBoardViewModel()
    
    /// notification: an instance of INNotification
    var notification: INNotification?
    
    /// isNotificationReceived: a static variable
    var isNotificationReceived = false
    
    /// isFromDashboard : a static variable
    var isFromDashboard = false
    
    //MARK: View life Cycle methods
    
    ///  displays a list of subscribed communites when view is loaded
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
        
        /// start OpenAPI flow
        OpenAPI.start(self)
        
        self.CommunityTableView.register(UINib(nibName: "DashBoardCommunitiesTableViewCell", bundle: .main), forCellReuseIdentifier: "DashBoardCommunitiesTableViewCell")
        
        /// adds an entry to the notification center to call the "didSbuscribeToCommunities" selector with the notification.
        NotificationCenter.default.addObserver(self, selector: #selector(didSubscribeToCommunities(notification:)), name: .subscriptionProcessDidComplete, object: nil)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackGround), name: UIApplication.willResignActiveNotification, object: nil)
        
        let notificationCenterTwo = NotificationCenter.default
        notificationCenterTwo.addObserver(self, selector: #selector(appMovedToForeGround), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    /// checks for notifications and locations permissions whenever the view is appeared
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Communities List"
        self.navigationController?.navigationItem.titleView?.tintColor = .white
        /// check for notification permissions
        self.viewModel.checkForNotificationPermissions(viewController: self)
        
        /// check for location permissions
        OpenAPI.didUpdateLocationStatus  { _ in
            self.viewModel.checkPermissions(called: "didUpdateLocationStatus" , viewController: self)
        }
        if isFromDashboard {
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    /// changes the isFromDashboard variable value which is responsible for toggling
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        isFromDashboard = false
    }
    
        //MARK: Static methods
    /// checks notifications and locations permissions when app moves to background
    @objc func appMovedToBackGround() {
        self.dismiss(animated: true)
    }
    
    /// checks notifications and locations permissions when app is in foreground
    @objc func appMovedToForeGround() {
        /// check for notification permissions
        self.viewModel.checkForNotificationPermissions(viewController: self)
        
        /// check for location permissions
        OpenAPI.didUpdateLocationStatus { _ in
            self.viewModel.checkPermissions(called: "didUpdateLocationStatus" , viewController: self)
        }
    }
    
    /// reloads the communityTableView
    @objc func didSubscribeToCommunities(notification: Notification) {
        DispatchQueue.main.async {
            self.CommunityTableView.reloadData()
        }
    }
}



//MARK: extension for UITableViewDelegate, UITableViewDataSource
/// this extension is responsible for handling communityTableView
extension DashBoardViewController : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDelegate, UITableViewDataSource Methods
    
    /// gives  count of subscribed communities
    /// - Parameters:
    ///   - tableView: communityTableView
    ///   - section: number of sections in a table view
    /// - Returns: cells count equal to  subscribed communities
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.subscribedCommunities.count == 0 {
            CommunityTableView.setMessage("No communities found at this moment")
        } else {
            CommunityTableView.clearBackground()
        }
        return self.viewModel.subscribedCommunities.count
    }
    
    /// assigns community names to cells of communityTableView
    /// - Parameters:
    ///   - tableView: communityTableView
    ///   - indexPath: the index path locating the row in the table view.
    /// - Returns: a list of community names assigned to cells of the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommunityTableView.dequeueReusableCell(withIdentifier: "DashBoardCommunitiesTableViewCell", for: indexPath) as! DashBoardCommunitiesTableViewCell
        let community = self.viewModel.subscribedCommunities[indexPath.row]
        cell.CommunityCellLabel.text = community.name
        return cell
    }
    
    /// gives  height of a table view cell
    /// - Parameters:
    ///   - tableView: communityTableView
    ///   - indexPath: the index path locating the row in the table view.
    /// - Returns: height of a table view cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// gives  height of a table view cell
    /// - Parameters:
    ///   - tableView: communityTableView
    ///   - indexPath: the index path locating the row in the table view.
    /// - Returns: height of a table view cell
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    ///  navigates to alert list screen when a cell is tapped
    /// - Parameters:
    ///   - tableView: communityTableView
    ///   - indexPath: the index path locating the row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// navigates to alert list screen when a community is tapped
        self.goToAlertList(with : self.viewModel.subscribedCommunities[indexPath.row])
    }
}


extension DashBoardViewController: INSubscriberManagerDelegate {
    
    //MARK: Static methods 
    /// gets subscribed communities and reloads the communityTableView 
    /// - Parameter subscribedCommunities: a list of subscribed communities 
    func subscribedCommunities(_ subscribedCommunities: [INCommunity]) {
        self.viewModel.subscribedCommunities = OpenAPI.getSubscribedCommunities()
        DispatchQueue.main.async {
            self.CommunityTableView.reloadData()
        }
    }
}
