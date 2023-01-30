//
//  AlertListTableViewCell.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 05/12/22.
//

import UIKit
import OpenAPI

class AlertListTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet for alertNameLabel,alertTypeLabel,alertDateLabel,mainCardView,alertDescriptionLabel
    
    @IBOutlet var alertNameLabel: UILabel!
    @IBOutlet var alertTypeLabel: UILabel!
    @IBOutlet var alertDateLabel: UILabel!
    @IBOutlet var mainCardView: UIView!
    @IBOutlet var alertDescriptionLabel: UILabel!
    
    // Variables declaration
    var notification : INNotification? {
        didSet {
            self.setData()
        }
    }
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
