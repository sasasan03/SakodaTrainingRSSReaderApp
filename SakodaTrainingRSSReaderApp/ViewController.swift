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
    static let storyBoardID = "Main"
    
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
    
    @IBOutlet weak var GoogleSignInButton: UIButton!
        
}
