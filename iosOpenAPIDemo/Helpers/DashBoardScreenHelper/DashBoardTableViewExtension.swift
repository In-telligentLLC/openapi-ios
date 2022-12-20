//
//  DashBoardTableViewExtension.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 20/12/22.
//

import Foundation
import UIKit

extension UITableView {
    
    func setMessage(_ message: String) {
        let customUILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        customUILabel.text = message
        customUILabel.textColor = .black
        customUILabel.numberOfLines = 0
        customUILabel.textAlignment = .center
        customUILabel.font = UIFont(name: "Arial", size: 20)
        customUILabel.sizeToFit()
        self.backgroundView = customUILabel
        self.separatorStyle = .none
    }
    
    func clearBackground() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
