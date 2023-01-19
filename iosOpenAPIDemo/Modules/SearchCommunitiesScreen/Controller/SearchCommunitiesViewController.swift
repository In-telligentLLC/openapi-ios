//
//  SearchCommunitiesViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit
import OpenAPI

class SearchCommunitiesViewController: UIViewController {
    
    @IBOutlet var SearchCommunitiesTableView: UITableView!
    @IBOutlet var CommunitySearchBar: UISearchBar!
    var filteredCommunities : [INCommunity] = []
    
    var viewModel = searchCommunitiesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Communities"
        self.SearchCommunitiesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        filteredCommunities = self.viewModel.searchCommunities
        CommunitySearchBar.delegate = self
    }
}

extension SearchCommunitiesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCommunities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let community = filteredCommunities[indexPath.row]
        cell.textLabel?.text = community.name
               return cell
    }
}

extension SearchCommunitiesViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCommunities = []
        if searchText == "" {
                       filteredCommunities = self.viewModel.searchCommunities
                    }
        for communities in self.viewModel.searchCommunities {
                        if communities.name.uppercased().contains(searchText.uppercased())
                        {
                            filteredCommunities.append(communities)
                        }
                    }
            self.SearchCommunitiesTableView.reloadData()
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.CommunitySearchBar.endEditing(true)
    }
    }
