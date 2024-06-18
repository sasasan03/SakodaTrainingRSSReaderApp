//
//  ViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/10.
// feat develop

import UIKit
import GoogleSignIn
import Firebase

enum FirebaseError: Error {
    case noID
    case missTackID
}

//class ViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let client = FirebaseClient()
//        GoogleSignInButton.addAction(UIAction { _ in
//            Task {
//                do {
//                    let signInResult = try await client.signIn()
//                    print("####",signInResult)
//                    if signInResult {
//                        guard let successView = self.storyboard?.instantiateViewController(withIdentifier: SuccessViewController.storyboardID) else { return print("#with Identifier miss") }
//                        self.present(successView, animated: true)
//                    } else {
//                        print("#signn  dissmiss")
//                    }
//                } catch {
//                    print("#error#", error.localizedDescription)
//                }
//            }
//        }, for: .touchUpInside)
//    }
//    
//    @IBOutlet weak var GoogleSignInButton: UIButton!
//        
//}


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleSignInButton.addAction(UIAction { _ in
            self.signIn()
        }, for: .touchUpInside)
    }
    
    @IBOutlet weak var GoogleSignInButton: UIButton!
    
    func signIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result,error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                    print("#Firebase Sign-In Error: \(error.localizedDescription)")
//                }
//                print("#User signed in with Google: \(authResult?.user.email ?? "メールアドレスなし")")
//            }
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    let authError = error as NSError
                    print(authError)
                    print("###error",authError.localizedDescription)
                    return
                }
                print("Googoleアカウントでサインしました。")
            }
        }
    }
    
}

