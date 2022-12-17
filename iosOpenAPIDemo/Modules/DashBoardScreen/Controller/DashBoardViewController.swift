//
//  DashBoardViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 01/12/22.
//

import UIKit
import OpenAPI

class DashBoardViewController: UIViewController {
    
    // Variables
    @IBOutlet var sideMenuButton: UIBarButtonItem!
    @IBOutlet var CommunityTableView: UITableView!
    var revealView: SWRevealViewController! = nil
    
    /*
    
    var viewModel = DashBoardViewModel()
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var nearbyCommunitiesCount: Int = 0 {
        didSet {
            nearbyCommunitiesCount = self.viewModel.allCommunities.count
        }
    }
    
    */
    
    
    //MARK: View life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Communities List"
        self.CommunityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
     //   setUpsideMenu()
        
        /*
       self.setupCommunityTableView()
        
        OpenAPI.configure(to: .uat, partnerToken: PartnerToken.getPartnerToken(),currentSandboxType: .dev)
        
        
        self.viewModel.communitiesFetchCompletion = { error in
            DispatchQueue.main.async {

                if let error = error {
                    self.showErrorMessage(error)
                }
                self.CommunityTableView.reloadData()
            }
        }
         */
        
    }
    
    /*
    func setUpsideMenu() {
        revealView = self.revealViewController()
        sideMenuButton.target = revealView
        sideMenuButton.action = #selector(revealView?.revealToggle(_:))
        self.revealViewController().tapGestureRecognizer().isEnabled = true
        self.revealViewController().panGestureRecognizer().isEnabled = true
    }
    
    func setupCommunityTableView() {

     //   CommunityTableView.registerNib(DashboardCommunitiesCollectionViewCell.self)
        
        CommunityTableView.delegate = self
        CommunityTableView.dataSource = self
        CommunityTableView.reloadData()
    }
    
    func setupCommunities(from: String) {
        
        self.viewModel.getCommunities()
        self.viewModel.communitiesFetchCompletion = { error in
            DispatchQueue.main.async {

                if let error = error {
                print("Error")
                }
                self.CommunityTableView.reloadData()
            }
        }
    }
   
     */
}

    
    
extension DashBoardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommunityTableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "Communities"
        return cell!
        /*
        if cell == nil {
            cell =  UITableViewCell(style: .default, reuseIdentifier: "cell"
        }
        
       // cell?.textLabel?.text = self.viewModel.allCommunities
        self.nearbyCommunitiesCount = self.viewModel.allCommunities.count
        return cell!
         */
        
    }
}



