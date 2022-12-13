//
//  SearchCommunitiesViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit

class SearchCommunitiesViewController: UIViewController {
    
    @IBOutlet var SearchCommunitiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Communities"
    }
}

extension SearchCommunitiesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell =  UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "Search Communities"
        return cell!
    }
}
