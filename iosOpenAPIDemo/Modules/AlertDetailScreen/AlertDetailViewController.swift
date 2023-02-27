//
//  AlertDetailsViewController.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 08/01/23.
//

import UIKit
import OpenAPI
import Localize

/// this class is responsible for handling the details of alert
class AlertDetailViewController: UIViewController, UITextViewDelegate {
    
    //MARK: Variables declaration
    
    /// viewModel - an instance of  AlertDetailViewModel class
    var viewModel = AlertDetailViewModel()
    
    /// translatedLanguage - static variable
    var translatedLanguage : String = "en"
    
    // MARK: IBOutlet Variables
    
    /// alertTitleLabel - to display the title of alert
    @IBOutlet weak var alertTitleLabel: UILabel!
    
    /// alertTimeLabel - to display  date and time of the alert
    @IBOutlet weak var alertTimeLabel: UILabel!
    
    /// alertMessageView - to display alert description
    @IBOutlet weak var alertMessageView : UITextView!
    
    ///alertTypeLabel  - to display type of the alert
    @IBOutlet var alertTypeLabel: UILabel!
    
    ///translateButton - languation translation button
    @IBOutlet var translateButton: UIButton!
    
    
    
    // MARK: View life cycle methods
    
    /// loads the details of alert and  "markOpened" API will be called
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
    
    /// gives title to the navigation bar whenever the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Alert Details"
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    /// gives title to the navigation bar whenever the view disappears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Alert Details"
    }
    
    
    // MARK: IBAction method
    /// on tapping translate button, calls getLanguages method implemented in INLanguageManager class
    /// - Parameter sender: tells who caused the action on button
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
    
    // MARK: Static methods
    
    /// updates the server whether notification is opened by user or not
    /// - Parameter notification: an optional value which contains the details of a the notification
    func markOpened(with notification : INNotification) {
        API.markOpened(notification, success: {
        }, failure: { _,_  in
        })
    }
    
    /// displays an action sheet with a list of languages
    /// - Parameter languages: an array which consists of language code and language name of all languages
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
    
    /// translate notification langauge to the user selected language
    /// - Parameter language: stores language code and language name of selected language
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
