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
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = userDefaultsManager.userIDLoad()
        setupGoogleSignInButton()
    }
    
    @IBOutlet weak var GoogleSignInButton: UIButton!
    
    private func setupGoogleSignInButton(){
        GoogleSignInButton.addAction(UIAction { _ in
            Task {
                do {
                    let signInResult = try await self.client.signIn()
                    if signInResult {
                        // 初回ログイン時とそれ以降のログインの遷移を管理。
                        if self.userID == nil {
                            guard let successView = self.storyboard?.instantiateViewController(
                                withIdentifier: SuccessViewController.storyboardID) else {
                                return print("?? The specified Storyboard cannot be found.(SuccessViewController.storyboardID)")
                            }
                            self.navigationController?.pushViewController(successView, animated: true)
                        } else {
                            guard let rssFeedSelectionVC = self.storyboard?.instantiateViewController(
                                withIdentifier: RSSFeedSelectionViewController.storyboardID) else {
                                return print("?? The specified Storyboard cannot be found.(UserSignUpViewController.storyboardID)")
                            }
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
