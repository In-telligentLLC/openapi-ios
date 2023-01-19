//
//  SideMenuViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    var fields = ["Home", "Search Communitites"]
    @IBOutlet var SideMenuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = .blue
        self.SideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SideMenuTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = fields[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0] :
            print("Home")
            revealViewController().revealToggle(animated: true)
        case [0,1]:
            print("Search Communities")
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
