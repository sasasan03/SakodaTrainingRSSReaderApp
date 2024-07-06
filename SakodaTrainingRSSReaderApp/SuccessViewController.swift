//
//  SuccessViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/18.
//

import UIKit

class SuccessViewController: UIViewController {
    static let storyboardID = "SuccessView"
    let firebaseClient = FirebaseClient()
    let userDefaultManager = UserDefaultsManager()
    
    @IBAction func signOut(_ sender: Any) {
        firebaseClient.signOut()
        userDefaultManager.delete()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
