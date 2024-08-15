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
    
    @IBOutlet weak var inputMailTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func didTapMailPasswordSignInButton(_ sender: Any) {
        Task {
            do {
                try await firebaseClient.mailPasswordSingIn(
                    mail: inputMailTextField.text,
                    password: inputPasswordTextField.text
                )
                guard let topics = self.topics else { throw ViewControllerError.topicsNotFound }
                let feedListVC = FeedListViewController(topics: topics)
                self.navigationController?.pushViewController(feedListVC, animated: true)
            }
            catch {
                print("🍹The email or password is incorrect.")
            }
        }
    }
    
    @IBOutlet weak var GoogleSignInButton: UIButton!
        
    @IBAction func didTapMailSignUpViewButton(_ sender: Any) {
        let mailSignUpVC = MailSingUpViewController()
        mailSignUpVC.title = "新規登録画面"
        let navigationViewController = UINavigationController(rootViewController: mailSignUpVC)
        navigationViewController.modalPresentationStyle = .automatic
        self.present(navigationViewController, animated: true)
    }
}

extension ViewController {
    
    enum ViewControllerError: Error {
        case topicsNotFound
        case userIDNotFound
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
