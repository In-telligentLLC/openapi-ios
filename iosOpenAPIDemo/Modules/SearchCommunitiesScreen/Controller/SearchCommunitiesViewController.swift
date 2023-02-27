//
//  SearchCommunitiesViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit
import OpenAPI

/// this class is responsible for searching a community from a list of communities
class SearchCommunitiesViewController: UIViewController {
    
    // MARK: IBOutlet variables
    
    /// SearchCommunitiesTableView: a table view which displays list of all communities
    @IBOutlet var SearchCommunitiesTableView: UITableView!
    
    ///CommunitySearchBar : a search bar where a community can be searched
    @IBOutlet var CommunitySearchBar: UISearchBar!
    
    // MARK: Variables declaration
    
    /// filteredCommunities: an array of type INCommunity
    var filteredCommunities : [INCommunity] = []

    /// viewModel : an instance of searchCommunitiesViewModel class
    var viewModel = searchCommunitiesViewModel()
    
    // MARK: View life cycle methods
    
    /// loads a list of all communities on the search communities screen
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
    
    //MARK: UITableViewDelegate, UITableViewDataSource methods
    /// gives count of all communities
    /// - Parameters:
    ///   - tableView: SearchCommunitiesTableView
    ///   - section: number of sections in a table view
    /// - Returns:returns count of all communities
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCommunities.count
    }
    
    
    /// gives community names to cells of the table view
    /// - Parameters:
    ///   - tableView: SearchCommunitiesTableView
    ///   - indexPath: the index path locating the row in the table view.
    /// - Returns: community names to the cells of table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let community = filteredCommunities[indexPath.row]
        /// displaying all the list of community names when the screen is launched
        cell.textLabel?.text = community.name
        return cell
    }
}

// MARK: extension for UISearchBarDelegate
/// this protocol contains methods which are implemented to make use of search bar and its functionality
extension SearchCommunitiesViewController : UISearchBarDelegate {
    
    //MARK: UISearchBarDelegate methods 
    /// if user changes the search text in search bar, the community list filters community names based on the search
    /// - Parameters:
    ///   - searchBar: the search bar that is being edited.
    ///   - searchText: the current text in the search text field.
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
    /// - Parameter searchBar: the search bar that is being edited.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.CommunitySearchBar.endEditing(true)
    }
}
