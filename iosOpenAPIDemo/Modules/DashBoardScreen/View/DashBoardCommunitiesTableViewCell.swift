//
//  DashBoardCommunitiesTableViewCell.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 13/12/22.
//

import UIKit
import OpenAPI

protocol DashboardCommunitiesCellDelegate: class {
  //  func didClickViewAll()
    func didSelectCommunity(_ community: INCommunity?)
}

class DashBoardCommunitiesTableViewCell: UITableViewCell {

    weak var delegate: DashboardCommunitiesCellDelegate?
    
    var communities: [INCommunity]? {
        didSet {
            DispatchQueue.main.async {
                self.tableviewReload()
               
//             //   guard let height = self.tababarHeight else {return }
            }
        }
    }
    
    func tableviewReload() {
        if communities?.count == 0 {
            print("No communities fetched")
         
     //       self.tableView.setEmptyView(with: "No communities at this moment.".localized(), shouldCenter: true)
        } else {
      //      self.tableView.restore()
     //       self.tableView.reloadData()
            print("Fetched all the communities")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
        
        
    }
    
}
