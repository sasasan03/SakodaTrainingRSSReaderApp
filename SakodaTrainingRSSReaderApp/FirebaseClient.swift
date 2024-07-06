//
//  FirebaseClient.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/18.
//

import Foundation
import Firebase
import FirebaseAuth

enum AuthenticationState: String, Codable {
    case unauthenticated
    case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class FirebaseClient{
    //TODO: 書き換える。依存を解消させる。
    let googleSignInClient = GoogleSignInClient()
    let userDefaultsMangaer = UserDefaultsManager()
    var authenticationState: AuthenticationState = .unauthenticated
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    /// ユーザーの認証状態が変わるたびに呼び出される。
    /// ユーザが現在ログインしているかログアウトしているかがわかる。
    /// ログアウトしていれば　『user』はnilを返す。
    /// 一度このメソッドを呼び出すと、authStateHandlerが登録され、明示的に解除しない限り、監視し続ける。
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                guard let user = user else { return print("?A? this user is not logged in") }
                let uid = user.uid
                self.userDefaultsMangaer.userIDSave(userID: uid)
                //          self.authenticationState = user == nil ? .unauthenticated : .authenticated
            }
        } else {
            print("# authStateHandlerは値を保持しています")
        }
    }
    
    /// 認証状態の変更を監視するリスナーを削除する関数。
    func unregisterAuthStateHandler() {
        if let authStateHandler = authStateHandler {
            Auth.auth().removeStateDidChangeListener(authStateHandler)
            self.authStateHandler = nil
            print("# authStateHandlerを削除しました")
        } else {
            print("# authStateHandlerは登録されていません")
        }
    }
    
    func hasUserEverSignedIn() -> Bool {
        
        return false
    }
    
    func signIn() async throws -> Bool {
        do {
            let userAuthentication = try await googleSignInClient.googleSignInResult()
            let user = userAuthentication.user
            guard let  idToken = user.idToken else {
                throw FirebaseError.missTackID
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString
            )
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("##user『\(firebaseUser.uid)』 signed in with email 『\(firebaseUser.email ?? "unknown")』")
            return true
        }
        catch {
            print("##sign in error",error.localizedDescription)
            return false
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("##sign out error")
        }
    }
    
    func deleteAccount() async -> Bool {
        return true
    }
}

