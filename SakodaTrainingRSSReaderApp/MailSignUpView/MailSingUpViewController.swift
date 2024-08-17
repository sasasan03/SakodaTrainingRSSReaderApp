//
//  MailSingUpViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/10.
//

import UIKit

class MailSingUpViewController: UIViewController {
    
    let firebaseClient = FirebaseClient()
    let validation = Validation()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    //　メールとパスワードのバリデーションをクリアしているか確認するためのプロパティ。
    var isFormValid: Bool = false {
        didSet {
            createUserButton.isEnabled = isFormValid
            createUserButton.alpha = isFormValid ? 1.0 : 0.2
        }
    }

    @IBOutlet weak var inputMailTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserButton.isEnabled = false
        createUserButton.alpha = 1.0
        createUserButton.setTitle("新規登録",for: .normal)
        createUserButton.setTitleColor(UIColor.red, for: .disabled)
        createUserButton.setTitleColor(UIColor.white, for: .normal)
        // メールの入力を検知
        inputMailTextField.addTarget(
            self,
            action: #selector(mailAndPasswordTextFieldDidChange),
            for: .editingChanged
        )
        // パスワードの入力を検知
        inputPasswordTextField.addTarget(
            self,
            action: #selector(mailAndPasswordTextFieldDidChange),
            for: .editingChanged
        )
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    @IBOutlet weak var createUserButton: UIButton!
    @IBAction func didTapCreatUserButton(_ sender: Any) {
        self.showActivityIndicator()
        Task {
            do {
                // 新規登録するためにメールとパスワードをFirebaseコンソールに登録する。
                try await firebaseClient.mailPasswordSignUp(
                    mail: inputMailTextField.text ?? "",
                    password: inputPasswordTextField.text ?? ""
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

//MARK: - Firebaseからuidをとってくる
extension MailSingUpViewController {
    
    func getUserID() throws -> UserID {
        guard let uid = firebaseClient.uid else {
            throw FirebaseClientError.notFoundUserID
        }
        return uid
    }
    
}

// MARK: - インジケーターの処理
extension MailSingUpViewController {
    
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

//MARK: - textFieldのイベントを検知して実行されるメソッド。
extension MailSingUpViewController {
    
    @objc func mailAndPasswordTextFieldDidChange() {
        let mailText = inputMailTextField.text ?? ""
        let passText = inputPasswordTextField.text ?? ""
        do {
            isFormValid = try validation.isValidEmail(mailText) &&
                              validation.isValidPassword(passText)
        } catch {
            print("#ViewController error", error.localizedDescription)
        }
    }
    
}
