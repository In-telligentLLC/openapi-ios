//
//  AlertDetailsViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 08/01/23.
//

import UIKit
import OpenAPI

class AlertDetailViewController: UIViewController, UITextViewDelegate {
    
    var viewModel = AlertDetailViewModel()
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertTimeLabel: UILabel!
    @IBOutlet weak var alertMessageView : UITextView!
    @IBOutlet var alertTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertMessageView.delegate = self
        guard let notification = self.viewModel.notification else { return }
        let titleTrimmedString = notification.title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.alertTitleLabel.text = titleTrimmedString
        let messageTrimmedString = notification.message.trimmingCharacters(in: .whitespacesAndNewlines)
        self.alertTypeLabel.text = "Alert type: \(notification._type)"
        self.alertMessageView.text = messageTrimmedString
        alertTimeLabel.text = notification.formattedDateString
        self.markOpened(with: notification)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Alert Details"
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Alert Details"
    }
    
    func markOpened(with notification : INNotification) {
        API.markOpened(notification, success: {
        }, failure: { _,_  in
        })
    }
}
