//
//  MailSingUpViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/10.
//

import UIKit

class MailSingUpViewController: UIViewController {
    
    let firebaseClient = FirebaseClient()

    @IBOutlet weak var inputMailTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapCreatUserButton(_ sender: Any) {
        firebaseClient.mailSignUp(email: inputMailTextField.text, password: inputPasswordTextField.text)
        self.dismiss(animated: true, completion: nil)
    }
}
