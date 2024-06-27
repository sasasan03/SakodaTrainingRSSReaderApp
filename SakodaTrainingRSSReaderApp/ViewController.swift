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
    let client = FirebaseClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("#",client.authenticationState)
        if client.authenticationState == .unauthenticated {
            navigateToLoginViewController()
        } else {
            navigateToSuccessViewController()
        }
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
    
    private func setRootViewController(_ viewController: UIViewController) {
        guard let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene),
              let window = windowScene.windows.first else {
            return
        }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
