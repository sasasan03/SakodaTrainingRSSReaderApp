//
//  FirebaseClient.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/18.
//

import Foundation
import Firebase
import FirebaseAuth

enum AuthenticationState {
  case unauthenticated
  case authenticating
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
    
    var flow: AuthenticationFlow = .login
    var authenticationState: AuthenticationState = .unauthenticated
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?

    func registerAuthStateHandler() {
      if authStateHandler == nil {
        // （addStateDidChangeListener）認証の状態変更を監視。認証状態が変わるたびに呼び出される。
        authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
            print("#user", user?.description)
          self.authenticationState = user == nil ? .unauthenticated : .authenticated
//          self.displayName = user?.email ?? ""
            print("#authStateHandler",self.authStateHandler?.description)
            print("#authenticationState",self.authenticationState)
        }
      } else {
          print("# authStateHandlerは値を保持しています")
      }
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

