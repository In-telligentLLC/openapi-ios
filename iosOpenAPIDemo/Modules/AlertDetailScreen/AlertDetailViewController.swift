//
//  AlertDetailsViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 08/01/23.
//

import UIKit
import OpenAPI
import Localize


class AlertDetailViewController: UIViewController, UITextViewDelegate {
    
    // Variables declaration
    var viewModel = AlertDetailViewModel()
    var translatedLanguage : String = "en"
    
    // MARK: IBOutlet for alertTitleLabel,alertTimeLabel,alertMessageView,alertTypeLabel,translateButton
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertTimeLabel: UILabel!
    @IBOutlet weak var alertMessageView : UITextView!
    @IBOutlet var alertTypeLabel: UILabel!
    @IBOutlet var translateButton: UIButton!
    
    
    // MARK: View life cycle methods
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
    
    /// updates the server whether notification is opened by user or not
    func markOpened(with notification : INNotification) {
        API.markOpened(notification, success: {
        }, failure: { _,_  in
        })
    }
    
    // MARK: IBOutlet action method
    @IBAction func tapOnTranslateButton(_ sender: Any) {
        showLoader {
            INLanguageManager.getLanguages({ [weak self] (languages) in
                DispatchQueue.main.async {
                    self?.hideLoader()
                    self?.displayLanguages(languages)
                }
            }, failure: { [weak self] (error, _) in
                DispatchQueue.main.async {
                    self?.hideLoader()
                    self?.showError(error)
                }
            })
        }
    }
    
    /// displays an action sheet with a list of languages
    private func displayLanguages(_ languages: [INLanguage]) {
        let title = "Translate to".localized + ":"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for language in languages {
            alert.addAction(UIAlertAction(title: language.name, style: .default, handler: { _ in
                DispatchQueue.main.async {
                }
                self.translateToLanguage(to: language)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    ///  translate notification langauge to the user selected language
    private func translateToLanguage(to language: INLanguage) {
        
        guard let notification = self.viewModel.notification else { return }
        self.showLoader {
            INLanguageManager.getTranslation(for: notification, to: language) { (translation) in
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.alertTitleLabel.text = translation.title
                    self.alertMessageView.text = translation.message
                    self.translatedLanguage = translation.language.code
                }
            } failure: { (error,errorCode) in
                DispatchQueue.main.async {
                    self.hideLoader()
                    if errorCode == 404 || errorCode == 403 {
                        self.showErrorMessage("There was an error connecting to the server".localized)
                    } else { self.showError(error) }
                }
            }
        }
    }
}
