//
//  ViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/10.
//  feat develop

import UIKit
import GoogleSignIn
import Firebase

enum FirebaseError: Error {
    case noID
    case missTackID
}

class ViewController: UIViewController {
    static let storyBoardID = "Main"
    let client = FirebaseClient()
    let userDefaultsManager = UserDefaultsManager()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var userID: String?
    
    @IBOutlet weak var inputMailTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = userDefaultsManager.userIDLoad()
        setupGoogleSignInButton()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    @IBAction func didTapMailPasswordSignInButton(_ sender: Any) {
        Task {
            do {
                let signInResult = try await client.mailPasswordSingIn(
                    mail: inputMailTextField.text,
                    password: inputPasswordTextField.text
                )
                if signInResult {
                    
                } else {
                    print("# ")
                }
            }
            catch {
                print("🍹The email or password is incorrect.")
            }
        }
    }
    
    @IBOutlet weak var GoogleSignInButton: UIButton!
        
    @IBAction func didTapMailSignUpViewButton(_ sender: Any) {
        let mailSignUpVC = MailSingUpViewController()
        let navigationViewController = UINavigationController(rootViewController: mailSignUpVC)
        navigationViewController.modalPresentationStyle = .automatic
        self.present(navigationViewController, animated: true)
    }
}

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
    // Googleアカウントでログイン
    // サインアップの場合はRSSFeedを選択する画面へ
    // ２回目以降のログインの場合はRSSFeed一覧画面へ遷移する
    private func setupGoogleSignInButton(){
        GoogleSignInButton.addAction(UIAction { _ in
            self.showActivityIndicator()
            Task {
                do {
                    let signInResult = try await self.client.googleSignIn()
                    if signInResult {
                        if self.userID != nil { // サインアップ時の遷移
                            guard let successView = self.storyboard?.instantiateViewController(
                                withIdentifier: SuccessViewController.storyboardID) else {
                                return print("?? The specified Storyboard cannot be found.(SuccessViewController.storyboardID)")
                            }
                            self.hideActivityIndicator()
                            self.navigationController?.pushViewController(successView, animated: true)
                        } else { // ログイン時の遷移
                            let rssFeedSelectionVC = RSSFeedSelectionViewController()
                            self.hideActivityIndicator()
                            self.navigationController?.pushViewController(rssFeedSelectionVC, animated: true)
                        }
                    } else {
                        print("#signn  dissmiss")
                    }
                } catch {
                    print("#error#", error.localizedDescription)
                }
            }
        }, for: .touchUpInside)
    }
}
