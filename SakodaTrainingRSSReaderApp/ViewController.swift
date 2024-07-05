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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ユーザーが登録状況取得
        client.registerAuthStateHandler()
        setupGoogleSignInButton()
//        do {
//            let authenticationState = try userDefaultsManager.loadCredentials()
//            if authenticationState == .authenticated {
//                navigateToSuccessViewController()
//            } else {
//                navigateToLoginViewController()
//            }
//        } catch {
//            
//        }
    }
    
    @IBOutlet weak var GoogleSignInButton: UIButton!
    
    private func setupGoogleSignInButton(){
        GoogleSignInButton.addAction(UIAction { _ in
            Task {
                do {
                    let signInResult = try await self.client.signIn()
                    if signInResult {
                        guard let successView = self.storyboard?.instantiateViewController(withIdentifier: SuccessViewController.storyboardID) else { return print("#with Identifier miss") }
                        self.navigationController?.pushViewController(successView, animated: true)
                        try self.userDefaultsManager.saveCredentials(authenticationState: .authenticated)
                    } else {
                        print("#signn  dissmiss")
                    }
                } catch {
                    print("#error#", error.localizedDescription)
                }
            }
        }, for: .touchUpInside)
    }

    
    private let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    
    private func navigateToSuccessViewController(){
        if let successViewController = storyboardInstance.instantiateViewController(withIdentifier: SuccessViewController.storyboardID) as? SuccessViewController {
            let navigationController =  UINavigationController(rootViewController: successViewController)
            setRootViewController(navigationController)
        }
    }
    
    private func navigateToLoginViewController(){
        if let loginViewController = storyboardInstance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as? LoginViewController {
            let navigationController =  UINavigationController(rootViewController: loginViewController)
            setRootViewController(navigationController)
        }
    }

    // アプリケーションのウィンドウのルートビューコントローラを設定し、表示する関数
    private func setRootViewController(_ viewController: UIViewController) {
        guard let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene),
              let window = windowScene.windows.first else {
            return
        }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    @IBAction func didTapToSignViewButton(_ sender: Any) {
        let userSignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: UserSignUpViewController.storyboardID) as! UserSignUpViewController
        self.navigationController?.pushViewController(userSignUpViewController, animated: true)
    }
    
    
}
