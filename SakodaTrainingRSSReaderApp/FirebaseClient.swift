//
//  FirebaseClient.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/18.
//

import Foundation
import Firebase
import GoogleSignIn


class FirebaseClient{
    
    //-----------------------------------------------------------------------
    func signIn() async throws -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else { throw FirebaseError.noID  }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            print("##There is no root view controller")
            return false
        }
        
        do {
            print("#1")
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            print("#2")
            let user = userAuthentication.user
            print("#3")
            guard let  idToken = user.idToken else {
                throw FirebaseError.missTackID
            }
            print("#4")
            let accessToken = user.accessToken
            print("#5")
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString
            )
            print("#6")//🍔ここまで呼ばれている。悪さをしているのは下。
            let result = try await Auth.auth().signIn(with: credential)
            print("#7")
            let firebaseUser = result.user
            
            print("#8")
            print("##user\(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            print("#9")
            return true
        }
        catch {
            print("#サインインエラー",error.localizedDescription)
            return false
        }
    }
    
    
    func signIn() { //クロージャを使って実装ViewControllerで実装
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!⭐️ViewControllerで実装していた
        //        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result,error in
        //            guard error == nil else {
        //                return
        //            }
        //
        //            guard let user = result?.user,
        //                  let idToken = user.idToken?.tokenString
        //            else {
        //                return
        //            }
        //
        //            let credential = GoogleAuthProvider.credential(
        //                withIDToken: idToken,
        //                accessToken: user.accessToken.tokenString
        //            )
        //
        //            Auth.auth().signIn(with: credential) { authResult, error in
        //                if let error = error {
        //                    print("#Firebase Sign-In Error: \(error.localizedDescription)")
        //                }
        //                print("#User signed in with Google: \(authResult?.user.email ?? "メールアドレスなし")")
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


