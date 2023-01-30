//
//  SearchCommunitiesViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit
import OpenAPI

class SearchCommunitiesViewController: UIViewController {
    
    // MARK: IBOutlet for searchCommunitiesTableView,CommunitySearchBar
    @IBOutlet var SearchCommunitiesTableView: UITableView!
    @IBOutlet var CommunitySearchBar: UISearchBar!
    
    // Variables declaration
    var filteredCommunities : [INCommunity] = []
    var viewModel = searchCommunitiesViewModel()
    
    // MARK: View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Communities"
        self.SearchCommunitiesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        /// storing all the subscribed and unsubscribed communities into filteredCommunities
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
        /// displaying all the list of community names when the screen is launched
        cell.textLabel?.text = community.name
        return cell
    }
}

// MARK: "UISearchBarDelegate" protocol contains methods which are implemented to make use of search bar and its functionality
extension SearchCommunitiesViewController : UISearchBarDelegate {
    
    /// if user changes the search text in search bar, filter community names based on the search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCommunities = []
        if searchText == "" {
            filteredCommunities = self.viewModel.searchCommunities
        }
        for communities in self.viewModel.searchCommunities {
            if communities.name.uppercased().contains(searchText.uppercased()){
                filteredCommunities.append(communities)
            }
        }
        self.SearchCommunitiesTableView.reloadData()
    }
    
    /// keyboard gets disappeared when search button is clicked on search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.CommunitySearchBar.endEditing(true)
    }
}
