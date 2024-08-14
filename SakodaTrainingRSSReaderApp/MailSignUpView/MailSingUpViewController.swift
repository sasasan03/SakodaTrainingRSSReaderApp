//
//  MailSingUpViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/10.
//

import UIKit

class MailSingUpViewController: UIViewController {
    
    let firebaseClient = FirebaseClient()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    @IBOutlet weak var inputMailTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    @IBAction func didTapCreatUserButton(_ sender: Any) {
        self.showActivityIndicator()
        Task {
            do {
                // 新規登録するためにメールとパスワードをFirebaseコンソールに登録する。
                try await firebaseClient.mailPasswordSignUp(
                    mail: inputMailTextField.text,
                    password: inputPasswordTextField.text
                )
                let uid = try getUserID()
                let selectedVC = RSSFeedSelectionViewController(userID: uid)
                self.hideActivityIndicator()
                self.navigationController?.pushViewController(selectedVC, animated: true)
            } catch {
                print("💫MailSingUpViewController signUp error：",error.localizedDescription)
            }
        }
    }
}

extension MailSingUpViewController {
    
    func getUserID() throws -> UserID {
        guard let uid = firebaseClient.uid else {
            throw FirebaseClientError.notFoundUserID
        }
        return uid
    }
    
    // インジケーターを表示にする
    private func showActivityIndicator() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    // インジケーターを非表示にする
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
}
