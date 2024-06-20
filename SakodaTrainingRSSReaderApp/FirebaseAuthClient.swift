//
//  FirebaseClient.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/18.
//

import Foundation
import Firebase
import GoogleSignIn

enum WindowsError: Error {
    case noClientID
    case noWindowScene
    case noRootViewController
//    case signInFailed(reason: String)
}

@MainActor
class GoogleSignInClient {
    
    func googleSignInResult() async throws -> GIDSignInResult {
        guard let clientID = FirebaseApp.app()?.options.clientID else { throw WindowsError.noClientID  }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window =  windowScene.windows.first,
              let rootViewController =  window.rootViewController else {
            print("##There is no root view controller")
            throw WindowsError.noRootViewController
        }
        
        return try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
    }
    
}


@MainActor
class FirebaseAuthClient{
    //TODO: 書き換える。依存を解消させる。
    let googleSignInClient = GoogleSignInClient()
    
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
            print("##user\(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return true
        }
        catch {
            print("#サインインエラー",error.localizedDescription)
            return false
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("##")
        }
    }
    
    func deleteAccount() async -> Bool {
        return true
    }
}

