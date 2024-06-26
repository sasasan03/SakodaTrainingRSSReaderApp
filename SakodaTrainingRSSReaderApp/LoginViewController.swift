//
//  LoginViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/26.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController {
    static let storyboardID = "LoginView"
    let client = FirebaseClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        client.registerAuthStateHandler()
        setupGoogleSignInButton()
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
                        //TODO: ここに保存処理を記述したい。
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
