//
//  SideMenuViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit

struct SideMenuItems {
    let title:String
    let imageName:String
}

class SideMenuViewController: UIViewController {
    
    var sideMenuContent:[SideMenuItems]! = nil
    
    @IBOutlet var SideMenuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuContent = [SideMenuItems(title: "Home", imageName: "homekit"),
                           SideMenuItems(title: "Search Communitites", imageName: "magnifyingglass")]
        self.revealViewController().navigationController?.navigationBar.barTintColor = .red
        self.SideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SideMenuTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = sideMenuContent[indexPath.row].title
        cell.imageView?.tintColor = .black
        cell.imageView?.image = UIImage(systemName:  sideMenuContent[indexPath.row].imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0] :
            revealViewController().revealToggle(animated: true)
        case [0,1]:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SearchCommunitiesViewController") as? SearchCommunitiesViewController {
                let navignController = revealViewController().frontViewController as! UINavigationController
                navignController.pushViewController(vc, animated: true)
                revealViewController().pushFrontViewController(navignController, animated: true)
            }
        default :
            print("Please select a cell")
        }
    }
}
