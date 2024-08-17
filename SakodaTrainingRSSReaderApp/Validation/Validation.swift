//
//  Validation.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/08/17.
//

import Foundation

struct Validation {
    
    enum MailAndPasswordError: Error {
        case invalidMail(String)
        case invalidPassword(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidMail(let message):
                return "\(message)"
            case .invalidPassword(let message):
                return "\(message)"
            }
        }
    }
    
//MARK: - メールアドレスのバリデーション。
    //『＠』前は英数字（大小文字）、ドット（.）、アンダースコア（_）、パーセント（%）、プラス（+）、ハイフン（-）のいずれかが1文字以上続く。
    //『＠』後は英数字（大小文字）、ドット（.）、ハイフン（-）が1文字以上続くことを許可。
    // 『.』以降、com: 「.com」 「.co.jp」「.jp」のドメインを許可。
    private func checkEmailFormat(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|co\\.jp|jp)"
        let emailTest = NSPredicate(format:  "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isValidEmail(_ email: String) throws -> Bool {
        guard !email.isEmpty else {
            throw MailAndPasswordError.invalidMail("メールアドレスを入力してください。")
        }
        
        guard checkEmailFormat(email) else {
            throw MailAndPasswordError.invalidMail("有効なメールアドレスを入力してください。")
        }
        return true
    }
    
//MARK: - パスワードのバリデーション
    //６文字以上であることを確認する
    private func checkPasswordFormat(_ password: String) -> Bool {
        let passwordRegEx = "^.{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func isValidPassword(_ password: String) throws -> Bool {
        
        guard !password.isEmpty else {
            throw MailAndPasswordError.invalidPassword("パスワードを入力してください。")
        }
        
        guard checkPasswordFormat(password) else {
            throw  MailAndPasswordError.invalidPassword("有効なパスワードを入力してください。")
        }
        
        return true
        
    }
    
}
