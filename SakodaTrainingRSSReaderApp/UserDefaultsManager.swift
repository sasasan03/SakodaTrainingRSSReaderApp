//
//  UserDefaultsManager.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/22.
//

import Foundation

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    static let key = "key"
    private let userDefaults = UserDefaults.standard
    
    func saveUserId(userID: String) {
        userDefaults.set(userID, forKey: UserDefaultsManager.key)
    }

    func loadUserId() -> String? {
        return userDefaults.string(forKey: UserDefaultsManager.key)
    }
    
    func register(topic: [Topic]) throws {
        guard let encoded = try? JSONEncoder().encode(topic) else {
            throw UserDefaultsError.encodingFailed
        }
        userDefaults.set(encoded, forKey: UserDefaultsManager.key)
    }
    
    var registeredTopics: [Topic]? {
        if let savedUserData = userDefaults.object(forKey: UserDefaultsManager.key) as? Data {
            return try? JSONDecoder().decode([Topic].self, from: savedUserData)
        }
            return nil
    }
    
    func saveAuthState(authenticationState: AuthenticationState) throws {
        let jsonData = try JSONEncoder().encode(authenticationState)
        userDefaults.set(jsonData, forKey: UserDefaultsManager.key)
    }
    
    func loadAuthState() throws -> AuthenticationState {
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
