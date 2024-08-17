//
//  FirebaseClientError.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/26.
//

import Foundation

enum FirebaseClientError: Error, LocalizedError {
    case notFoundUserID
    case userNotLoggedIn
    case missingCredentials
    case signInFailed(String)
    case invalidEmailOrPassword
    case signOutFailed
    case authStateListenerAlreadyRegistered

    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .notFoundUserID:
            return "userIDを見つけることができませんでした。"
        case .userNotLoggedIn:
            return "ユーザーがログインしていません。"
        case .missingCredentials:
            return "資格情報が見つかりません。"
        case .signInFailed(let message):
            return "\(message)"
        case .invalidEmailOrPassword:
            return "無効なメールアドレスまたはパスワードです。"
        case .signOutFailed:
            return "サインアウトに失敗しました。"
        case .authStateListenerAlreadyRegistered:
            return "認証状態リスナーは既に登録されています。"
        case .unknownError:
            return "不明なエラーが発生しました。"
        }
    }
}



enum AuthenticationState: String, Codable {
    case unauthenticated
    case authenticated
    
    var description: String {
        switch self {
        case .unauthenticated:
            return "未認証"
        case .authenticated:
            return "認証済み"
        }
    }
}

enum AuthenticationFlow {
    case login
    case signUp
    
    var description: String {
        switch self {
        case .login:
            return "ログイン"
        case .signUp:
            return "サインアップ"
        }
    }
}
