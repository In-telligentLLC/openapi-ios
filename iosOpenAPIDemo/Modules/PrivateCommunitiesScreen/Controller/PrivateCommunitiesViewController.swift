//
//  PrivateCommunitiesViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit

class PrivateCommunitiesViewController: UIViewController {
    
    @IBOutlet var PrivateCommunityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Private Communities"
    }
}

extension PrivateCommunitiesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell =  UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "Private Communities"
        return cell!
    }
}
