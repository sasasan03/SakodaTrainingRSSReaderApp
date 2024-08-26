//
//  MailAndPasswordError.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/08/18.
//

import Foundation

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
