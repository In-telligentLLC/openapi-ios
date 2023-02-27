//
//  DashBoardCommunitiesTableViewCell.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 13/12/22.
//

import UIKit

/// this class is responsible in handling cell of a CommunityTableView
class DashBoardCommunitiesTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet variables
    
    /// CommunityCellLabel: a label in CommunityTableView
    @IBOutlet var CommunityCellLabel: UILabel!
    
    //MARK: UITableViewCell methods
    
    /// an instance method added when an xib cell is added
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    ///  an instance method added when an xib cell is added
    /// - Parameters:
    ///   - selected: a boolean value
    ///   - animated: a boolean value 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


