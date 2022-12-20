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
        revealView = self.revealViewController()
        sideMenuButton.target = revealView
        sideMenuButton.action = #selector(revealView?.revealToggle(_:))
        self.title = "Communities List"
        self.CommunityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.subscribedCommunities = OpenAPI.getSubscribedCommunities()
        //   subscribedCommunities = []
        OpenAPI.start(self)
        self.CommunityTableView.reloadData()
    }
}

extension DashBoardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subscribedCommunities.count == 0 {
            CommunityTableView.setMessage("No communities found at this moment")
        } else {
            CommunityTableView.clearBackground()
        }
        return subscribedCommunities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommunityTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let community = subscribedCommunities[indexPath.row]
        cell.textLabel?.text = community.name
        return cell
    }
}

extension DashBoardViewController : INSubscriberManagerDelegate {
    
    func subscribedCommunities(_ subscribedCommunities: [INCommunity]) {
        print(subscribedCommunities)
    }
}
