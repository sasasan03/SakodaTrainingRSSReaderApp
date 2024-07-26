//
//  FirebaseClientError.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/26.
//

import Foundation

enum FirebaseClientError: Error {
    case userNotLoggedIn
    case missingIDToken
    case signInFailed
    case invalidEmailOrPassword
    case signOutFailed
    case authStateListenerAlreadyRegistered
    case unknownError
}
