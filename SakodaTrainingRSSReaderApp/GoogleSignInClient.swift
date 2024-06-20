//
//  GoogleSignInClient.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/20.
//

import Foundation
import Firebase
import GoogleSignIn

@MainActor
class GoogleSignInClient {
    
    enum WindowsError: Error {
        case noClientID
        case noWindowScene
        case noRootViewController
    //    case signInFailed(reason: String)
    }
    
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
