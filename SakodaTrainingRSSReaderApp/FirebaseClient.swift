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
    var uid: UserID?
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
                //                do {
                //                    try self.userDefaultsMangaer.saveUserId(userID: uid)
                //                } catch {
                //                    print("#error",error.localizedDescription)
                //                }
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
    
    // この関数を実行するとuidに値が入る
    func googleSignIn() async throws {
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
            let userID = UserID(id: uid)
            self.uid = userID
        }
        catch {
            throw FirebaseClientError.signInFailed("googleログインに失敗しました。")
        }
    }
    
    func mailPasswordSingIn(mail: String?, password: String?) async throws {
        guard let mail, !mail.isEmpty else {
            throw FirebaseClientError.invalidMail("メールアドレスを入力してください。")
        }
        
        guard let password, !password.isEmpty else {
            throw FirebaseClientError.invalidPassword("パスワードを入力してください。")
        }
        
        guard isValidEmail(mail) else {
            throw FirebaseClientError.invalidMail("有効なメールアドレスを入力してください。")
        }
        
        guard isValidPassword(password) else {
            throw  FirebaseClientError.invalidPassword("有効なパスワードを入力してください。")
        }
        
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: mail, password: password)
            let user = authDataResult.user
            let userID = UserID(id: user.uid)
            self.uid = userID
        }
        catch {
            throw FirebaseClientError.signInFailed("メールログインに失敗しました。")
        }
    }
    
    func mailPasswordSignUp(mail: String, password: String, completion: () -> Void){
        Auth.auth().createUser(withEmail: mail, password: password)
        completion()
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        }
        catch {
            throw FirebaseClientError.signOutFailed
        }
    }
    
    func deleteAccount() async -> Bool {
        return true
    }
    
    // メールアドレスのバリデーション
    //『＠』前は英数字（大小文字）、ドット（.）、アンダースコア（_）、パーセント（%）、プラス（+）、ハイフン（-）のいずれかが1文字以上続く。
    //『＠』後は英数字（大小文字）、ドット（.）、ハイフン（-）が1文字以上続くことを許可。
    // 『.』以降、com: 「.com」 「.co.jp」「.jp」のドメインを許可。
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|co\\.jp|jp)"
        let emailTest = NSPredicate(format:  "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    // パスワードのバリデーション(６文字以上であることを確認する)
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^.{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
}

