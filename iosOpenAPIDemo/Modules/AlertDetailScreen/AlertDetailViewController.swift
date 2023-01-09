//
//  AlertDetailsViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 08/01/23.
//

import UIKit
import OpenAPI

class AlertDetailViewController: UIViewController {
    
    var viewModel = AlertDetailViewModel()
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertTimeLabel: UILabel!
    @IBOutlet weak var alertMessageView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Alert Details"
        guard let notification = self.viewModel.notification else { return }
        let titleTrimmedString = notification.title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.alertTitleLabel.text = titleTrimmedString
        let messageTrimmedString = notification.message.trimmingCharacters(in: .whitespacesAndNewlines)
        self.alertMessageView.text = messageTrimmedString
        self.alertMessageView.isUserInteractionEnabled = false
        alertTimeLabel.text = notification.formattedDateString
    }
}
