//
//  ViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/10.
//  feat develop

import UIKit
import GoogleSignIn
import Firebase

class ViewController: UIViewController {
    
    static let storyBoardID = "Main"
    let firebaseClient = FirebaseClient()
    let userDefaultsManager = UserDefaultsManager.shared
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var topics: [Topic]?
    var uid: UserID?
    let validation = Validation()
    @IBOutlet weak var inputMailTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailpasswordSignInButton.isEnabled = false
        mailpasswordSignInButton.alpha = 1.0
        mailpasswordSignInButton.setTitle("ログイン",for: .normal)
        mailpasswordSignInButton.setTitleColor(UIColor.red, for: .disabled)
        mailpasswordSignInButton.setTitleColor(UIColor.blue, for: .normal)
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
        do {
            self.uid = try userDefaultsManager.loadUserId()
            self.topics = try userDefaultsManager.loadTopics()
        } catch {
            print("#VC error#",error.localizedDescription)
        }
        setupGoogleSignInButton()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    //メールとパスワードでログインするために使用するボタンとアクション。
    @IBOutlet weak var mailpasswordSignInButton: UIButton!
    @IBAction func didTapMailPasswordSignInButton(_ sender: Any) {
        Task {
            do {
                let mail = inputMailTextField.text ?? ""
                let pass = inputPasswordTextField.text ?? ""
                _ = try validation.isValidEmail(mail)
                _ = try validation.isValidPassword(pass)
                try await firebaseClient.mailPasswordSingIn(
                    mail: mail,
                    password: pass
                )
                guard let topics = self.topics else { 
                    throw ViewControllerError.topicsNotFound
                }
                let feedListVC = FeedListViewController(topics: topics)
                self.navigationController?.pushViewController(feedListVC, animated: true)
            }
            catch let error as MailAndPasswordError {
                if let errorDescription = error.errorDescription {
                    AlertHelper.showAlert(
                        on: self,
                        message: errorDescription
                    )
                } else {
                    print("#unknown error.")
                }
            }
            catch let error as AuthErrorCode {
                print("Error code: \(error.code)")
                print("Error description: \(error.localizedDescription)")
                let errorMessage = AlertHelper.handleAuthError(error)
                AlertHelper.showAlert(on: self, message: errorMessage)
            }
            catch {
                print("#unknown error.")
            }
        }
    }
    
    var isFormValid: Bool = false {
        didSet {
            mailpasswordSignInButton.isEnabled = isFormValid
            if isFormValid {
                mailpasswordSignInButton.setTitleColor(UIColor.blue, for: .normal)
            } else {
                mailpasswordSignInButton.setTitleColor(UIColor.red, for: .disabled)
            }
        }
    }
    
    // Googleアカウントでログインするためのボタン。処理はextentionに記述。
    @IBOutlet weak var GoogleSignInButton: UIButton!
    
    // サインアップの画面を表示させるためのボタンアクション。
    @IBAction func didTapMailSignUpViewButton(_ sender: Any) {
        let mailSignUpVC = MailSingUpViewController()
        mailSignUpVC.title = "新規登録画面"
        let navigationViewController = UINavigationController(rootViewController: mailSignUpVC)
        navigationViewController.modalPresentationStyle = .fullScreen
        self.present(navigationViewController, animated: true)
    }
    
}

//MARK: - ViewController内のエラーのenum。
extension ViewController {
    
    enum ViewControllerError: Error {
        case topicsNotFound
        case userIDNotFound
    }
    
}

//MARK: - textFieldのイベントを検知して実行されるメソッド。
extension ViewController {
    
    @objc func mailAndPasswordTextFieldDidChange() {
        let mailText = inputMailTextField.text ?? ""
        let passText = inputPasswordTextField.text ?? ""
        isFormValid = checkMailAndPasswordTextFieldCount(mailText: mailText, passText: passText)
    }
    
    private func checkMailAndPasswordTextFieldCount(mailText: String, passText: String) -> Bool {
        return (0 < mailText.count) && (0 < passText.count)
    }
    
}

//MARK: - インジケータに関するメソッド。
extension ViewController {
    
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

//MARK: - Googleログインボタンに関するメソッド
extension ViewController {

    // ２回目以降のログインの場合はRSSFeed一覧画面へ遷移する
    private func setupGoogleSignInButton() {
        GoogleSignInButton.addAction(UIAction { _ in
            self.showActivityIndicator()
            Task {
                do {
                    try await self.firebaseClient.googleSignIn()
                    
                    if let topVC = self.navigationController?.topViewController, 
                        topVC.isKind(of: FeedListViewController.self) ||
                        topVC.isKind(of: RSSFeedSelectionViewController.self) {
                        self.hideActivityIndicator()
                        print("VC: 意図しない重複遷移や、同じViewControllerを複数回表示しようとしています。")
                        return
                    }
                    if self.uid != nil { // ニュースフィード一覧へ
                        guard let topics = self.topics else { throw ViewControllerError.topicsNotFound }
                        let feedListVC = FeedListViewController(topics: topics)
                        self.hideActivityIndicator()
                        self.navigationController?.pushViewController(feedListVC, animated: true)
                    } else { // 選択画面へ
                        guard let userID = self.firebaseClient.uid else { throw ViewControllerError.userIDNotFound }
                        let rssFeedSelectionVC = RSSFeedSelectionViewController(userID: userID)
                        self.hideActivityIndicator()
                        self.navigationController?.pushViewController(rssFeedSelectionVC, animated: true)
                    }
                } catch {
                    print("#error#", error.localizedDescription)
                }
            }
        }, for: .touchUpInside)
    }
}
