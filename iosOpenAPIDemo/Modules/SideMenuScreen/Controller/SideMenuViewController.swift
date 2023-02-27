//
//  SideMenuViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit

// MARK: Declaring a struct

/// this struct is responsible for handling side menu items
struct SideMenuItems {
    //MARK: Variables declaration
    
    /// title : title of items in side menu
    let title:String
    
    /// imageName : image names for items in side menu
    let imageName:String
}

/// this class is responsible for handling side menu
class SideMenuViewController: UIViewController {
    
    //MARK: variables declaration
    ///sideMenuContent: a variable which stores items of side menu
    var sideMenuContent:[SideMenuItems]! = nil
    
    // MARK: IBOutlet variables 
    /// SideMenuTableView : a table view to display items of a side menu
    @IBOutlet var SideMenuTableView: UITableView!
    
    // MARK: View life cycle methods
    
    ///displays side menu options and navigates to respective screens when respective cells are tapped .
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///setting sidemenu content
        sideMenuContent = [SideMenuItems(title: "Home", imageName: "homekit"),
                           SideMenuItems(title: "Search Communitites", imageName: "magnifyingglass")]
        self.revealViewController().navigationController?.navigationBar.barTintColor = .red
        /// registering cell for sidemenu tableView  with identifier "cell"
        self.SideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDelegate, UITableViewDataSource methods 
    /// gives count of side menu options
    /// - Parameters:
    ///   - tableView: sideMenuTableView
    ///   - section: number of sections in table view
    /// - Returns:returns count of side menu options
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuContent.count
    }
    
    
    ///  gives title and image to the cells of sideMenuTableView
    /// - Parameters:
    ///   - tableView:sideMenuTableView
    ///   - indexPath:  the index path locating the row in the table view.
    /// - Returns: returns cells of table view cells will values like title and image
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SideMenuTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = sideMenuContent[indexPath.row].title
        cell.imageView?.tintColor = .black
        cell.imageView?.image = UIImage(systemName:  sideMenuContent[indexPath.row].imageName)
        return cell
    }
    
    /// gives height of a cell in table view
    /// - Parameters:
    ///   - tableView: sideMenuTableView
    ///   - indexPath: the index path locating the row in the table view.
    /// - Returns: returns  height of a cell in table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    /// navigates to respective screens when a cell is tapped
    /// - Parameters:
    ///   - tableView: sideMenuTableView
    ///   - indexPath: the index path locating the row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0] :
            revealViewController().revealToggle(animated: true)
        case [0,1]:
            /// navigating to search communities screen
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
