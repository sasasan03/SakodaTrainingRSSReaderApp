//
//  UserDefaultsManager.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/22.
//

import Foundation

struct UserDefaultsManager {
    static let key = "key"
    let userDefaults = UserDefaults.standard
    
    func primitiveSave(userID: String) {
        userDefaults.set(userID, forKey: UserDefaultsManager.key)
    }
    
    func primitiveLoad() -> String {
        guard let userID = userDefaults.string(forKey: UserDefaultsManager.key) else {
            return "not found userID"
        }
        return userID
    }
}
