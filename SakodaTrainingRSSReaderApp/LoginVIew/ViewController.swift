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
    let client = FirebaseClient()
    let userDefaultsManager = UserDefaultsManager.shared
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var topics: [Topic]?
    var uid: String?
    
    @IBOutlet weak var inputMailTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uid = userDefaultsManager.loadUserId()
        print("#vc uid viewDid", self.uid)
        do {
            self.topics = try userDefaultsManager.loadTopics()
            print("#vc topics viewDid", self.topics)
        } catch {
            print("#VC error",error)
        }
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
        mailSignUpVC.title = "新規登録画面"
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
                    // UserDefaults内にuidを保持していれば、一覧画面へ
//                    let uid = self.userDefaultsManager.loadUserId()
                    if let topics = self.topics {
                        let topics = try self.userDefaultsManager.loadTopics()
                        _ = try await self.client.googleSignIn()
                        let feedListVC = FeedListViewController(topics: topics)
                        self.hideActivityIndicator()
                        self.navigationController?.pushViewController(feedListVC, animated: true)
                    } else { // 選択画面へ
                        let uid = try await self.client.googleSignIn()
                        print("#uid VC 🍔",self.userDefaultsManager.loadUserId())
                        self.userDefaultsManager.saveUserId(userID: uid)
                        print("#uid VC 🍟",self.userDefaultsManager.loadUserId())
                        let rssFeedSelectionVC = RSSFeedSelectionViewController()
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
