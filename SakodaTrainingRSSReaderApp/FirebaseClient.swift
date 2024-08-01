//
//  FirebaseClient.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/18.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

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
                guard let user = user else { return print("🍹 this user is not logged in") }
                let uid = user.uid
                self.userDefaultsMangaer.saveUserId(userID: uid)
                //          self.authenticationState = user == nil ? .unauthenticated : .authenticated
            }
        } else {
            print("# authStateHandler has Listener")
        }
    }
    
    /// 認証状態の変更を監視するリスナーを削除する関数。
    func unregisterAuthStateHandler() {
        if let authStateHandler = authStateHandler {
            Auth.auth().removeStateDidChangeListener(authStateHandler)
            self.authStateHandler = nil
            print("# delete authStateHandler")
        } else {
            print("# has no authStateHandler")
        }
    }
    
    func googleSignIn() async throws -> String {
        do {
            // Googleサインインクライアントからサインイン結果を取得
            let userAuthentication = try await googleSignInClient.googleSignInResult()
            let user = userAuthentication.user
            
            // ユーザーのIDトークンを取得
            guard let  idToken = user.idToken else {
                throw FirebaseClientError.noID
            }
            
            // ユーザーのアクセストークンを取得
            let accessToken = user.accessToken
            
            // Googleの資格情報を作成
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString
            )
            
            // Firebaseでサインイン
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            
            // サインインしたユーザーのUIDを取得
            let uid = firebaseUser.uid
            
            return uid
        }
        catch {
            throw FirebaseClientError.signInFailed
        }
    }
    
    func mailPasswordSingIn(mail: String?, password: String?) async throws -> Bool {
        // TODO: エラー処理の記述を行う
        guard let mail else {
            return false
        }
        guard let password else {
            return false
        }
        
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: mail, password: password)
            //🍔uidを保持しているか、いないかでBoolを返す
//            let uid = authDataResult.user.uid
            return true
        }
        catch {
            print("🍹 Sign in method failed")
            return false
        }
    }
    
    func mailPasswordSignUp(mail: String, password: String, completion: () -> Void){
        Auth.auth().createUser(withEmail: mail, password: password)
        completion()
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("🍹 sign out error")
        }
    }
    
    func deleteAccount() async -> Bool {
        return true
    }
}

