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
        guard let mail = inputMailTextField.text,
              let password = inputPasswordTextField.text,
              !mail.isEmpty && !password.isEmpty else {
            //TODO: エラー処理を追加
            return print("🍹mail and password is invalid value.")
        }
        firebaseClient.mailPasswordSignUp(mail: mail, password: password) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
