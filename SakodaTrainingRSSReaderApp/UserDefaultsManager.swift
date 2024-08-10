//
//  UserDefaultsManager.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/22.
//

import Foundation
import UIKit

struct UserID: Codable {
    let id: String
}

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    static let topicsKey = "topicsKey"
    static let idKey = "idKey"
    static let styleKey = "styleKey"
    private let userDefaults = UserDefaults.standard
    
    func saveUserId(userID: UserID) throws {
        do {
            let encoded = try JSONEncoder().encode(userID)
            userDefaults.set(encoded, forKey: UserDefaultsManager.idKey)
        } catch {
            throw UserDefaultsError.encodingFailed
        }
    }
    
    func loadUserId() throws -> UserID? {
        guard let data = userDefaults.object(forKey: UserDefaultsManager.idKey) as? Data else {
            throw UserDefaultsError.dataNotFound
        }
        do {
            return try JSONDecoder().decode(UserID.self, from: data)
        } catch {
            throw UserDefaultsError.decodingFailed
        }
    }
    
    func saveTopics(topic: [Topic]) throws {
        guard let encoded = try? JSONEncoder().encode(topic) else {
            throw UserDefaultsError.encodingFailed
        }
        userDefaults.set(encoded, forKey: UserDefaultsManager.topicsKey)
    }
    
    func loadTopics() throws -> [Topic] {
        guard let data = userDefaults.object(forKey: UserDefaultsManager.topicsKey) as? Data else {
            throw UserDefaultsError.dataNotFound
        }
        return try JSONDecoder().decode([Topic].self, from: data)
    }
    
    func saveDarkModePreference(isDarkMode: Bool){
        let style = isDarkMode ? UIUserInterfaceStyle.dark : UIUserInterfaceStyle.light
        userDefaults.set(style.rawValue, forKey: UserDefaultsManager.styleKey)
    }
    
    func loadDarkModePreference() throws -> UIUserInterfaceStyle? {
        guard let saveStyle = userDefaults.value(forKey: UserDefaultsManager.styleKey) as? Int else {
            throw UserDefaultsError.styleKeyNotFound
        }
        
        guard let style =  UIUserInterfaceStyle(rawValue: saveStyle) else {
            throw UserDefaultsError.invalidStyleValue
        }
        
        return style
    }
    
    func saveAuthState(authenticationState: AuthenticationState) throws {
        let jsonData = try JSONEncoder().encode(authenticationState)
        userDefaults.set(jsonData, forKey: UserDefaultsManager.topicsKey)
    }
    
    func loadAuthState() throws -> AuthenticationState {
        guard let jsonData = userDefaults.data(forKey: UserDefaultsManager.topicsKey) else {
            return AuthenticationState.unauthenticated
        }
        let data = try JSONDecoder().decode(AuthenticationState.self, from: jsonData)
        return data
    }
    
    func topicsDataDelete() {
        userDefaults.removeObject(forKey: UserDefaultsManager.topicsKey)
    }
    
    func idDataDelete() {
        userDefaults.removeObject(forKey: UserDefaultsManager.idKey)
    }
    
}
