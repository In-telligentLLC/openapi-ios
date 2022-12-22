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
    
    // Variables
    @IBOutlet var sideMenuButton: UIBarButtonItem!
    @IBOutlet var CommunityTableView: UITableView!
    var revealView: SWRevealViewController! = nil
    var subscribedCommunities : [INCommunity] = []
    
    //MARK: View life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = .blue
        
        revealView = self.revealViewController()
        sideMenuButton.target = revealView
        sideMenuButton.action = #selector(revealView?.revealToggle(_:))
        
        self.title = "Communities List"
        
        OpenAPI.start(self)
        
        self.CommunityTableView.register(UINib(nibName: "DashBoardCommunitiesTableViewCell", bundle: .main), forCellReuseIdentifier: "DashBoardCommunitiesTableViewCell")
    }
}

extension DashBoardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if subscribedCommunities.count == 0 {
            CommunityTableView.setMessage("No communities found at this moment")
        } else {
            CommunityTableView.clearBackground()
        }
        return self.subscribedCommunities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommunityTableView.dequeueReusableCell(withIdentifier: "DashBoardCommunitiesTableViewCell", for: indexPath) as! DashBoardCommunitiesTableViewCell
        let community = self.subscribedCommunities[indexPath.row]
        cell.CommunityCellLabel.text = community.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension DashBoardViewController : INSubscriberManagerDelegate {
    
    func subscribedCommunities(_ subscribedCommunities: [INCommunity]) {
        self.subscribedCommunities = subscribedCommunities
        DispatchQueue.main.async { [weak self] in
            self?.CommunityTableView.reloadData()
        }
        print("subscribedCommunities", self.subscribedCommunities)
    }
}
