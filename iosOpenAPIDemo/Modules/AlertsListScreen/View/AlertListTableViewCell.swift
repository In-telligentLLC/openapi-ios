//
//  AlertListTableViewCell.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit
import OpenAPI

/// this class is responsible for displaying content of alert in alertListTableView
class AlertListTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet variables
    
    /// alertNameLabel : displays name of alert
    @IBOutlet var alertNameLabel: UILabel!
    /// alertTypeLabel : displays type of alert
    @IBOutlet var alertTypeLabel: UILabel!
    ///alertDateLabel: displays date and time of alert
    @IBOutlet var alertDateLabel: UILabel!
    ///mainCardView : displays content of each alert in card format
    @IBOutlet var mainCardView: UIView!
    /// alertDescriptionLabel: displays description of alert
    @IBOutlet var alertDescriptionLabel: UILabel!
    
    //MARK: Variables declaration
    /// notification :  instance of INNotification
    var notification : INNotification? {
        didSet {
            self.setData()
        }
    }
    
    //MARK: Static methods
    /// setting notification name, notification type, notification message, notification date, cardView style and features
    func setData() {
        guard let notification = self.notification else { return }
        let descriptionTrimmedString = notification.message.trimmingCharacters(in: .whitespacesAndNewlines)
        self.alertDescriptionLabel.text = descriptionTrimmedString
        let nameTrimmedString = notification.title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.alertNameLabel.text = nameTrimmedString
        self.alertTypeLabel.text = self.notification?.type.localizedString.uppercased()
        self.alertDateLabel.text = notification.formattedDateString
        self.mainCardView.layer.cornerRadius = 10.0
        self.mainCardView.layer.borderWidth = 0.5
        self.mainCardView.layer.borderColor = UIColor.lightGray.cgColor
        self.mainCardView.layer.shadowColor = UIColor.lightGray.cgColor
        self.mainCardView.layer.shadowRadius = 0.5
    }
    
    //MARK: TableViewCell methods 
    ///an instance method added when an xib cell is added
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    /// an instance method added when an xib cell is added
    /// - Parameters:
    ///   - selected: a boolean value
    ///   - animated: a boolean value
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
