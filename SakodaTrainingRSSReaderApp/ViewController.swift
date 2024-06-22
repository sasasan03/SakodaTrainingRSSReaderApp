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

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let client = FirebaseClient()
        client.registerAuthStateHandler()
        GoogleSignInButton.addAction(UIAction { _ in
            Task {
                do {
                    let signInResult = try await client.signIn()
                    if signInResult {
                        guard let successView = self.storyboard?.instantiateViewController(withIdentifier: SuccessViewController.storyboardID) else { return print("#with Identifier miss") }
                        self.navigationController?.pushViewController(successView, animated: true)
                    } else {
                        print("#signn  dissmiss")
                    }
                } catch {
                    print("#error#", error.localizedDescription)
                }
            }
        }, for: .touchUpInside)
    }
    
    @IBOutlet weak var GoogleSignInButton: UIButton!
        
}
