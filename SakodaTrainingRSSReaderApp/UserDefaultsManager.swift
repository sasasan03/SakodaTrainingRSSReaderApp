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
    
    func userIDSave(userID: String) {
        userDefaults.set(userID, forKey: UserDefaultsManager.key)
    }

    func userIDLoad() -> String? {
        return userDefaults.string(forKey: UserDefaultsManager.key)
    }
    
    func saveCredentials(authenticationState: AuthenticationState) throws {
        let jsonData = try JSONEncoder().encode(authenticationState)
        userDefaults.set(jsonData, forKey: UserDefaultsManager.key)
    }
    
    func loadCredentials() throws -> AuthenticationState {
        guard let jsonData = userDefaults.data(forKey: UserDefaultsManager.key) else {
            return AuthenticationState.unauthenticated
        }
        let data = try JSONDecoder().decode(AuthenticationState.self, from: jsonData)
        return data
    }
    
    func delete() {
        userDefaults.removeObject(forKey: UserDefaultsManager.key)
    }
    
}
