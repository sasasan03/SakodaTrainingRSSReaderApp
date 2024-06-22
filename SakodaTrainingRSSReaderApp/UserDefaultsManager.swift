//
//  UserDefaultsManager.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/22.
//

import Foundation

struct UserDefaultsManager {
     static let key = "key"
    
    func save(text: String) throws {
        let jsonData = try JSONEncoder().encode(text)
        UserDefaults.standard.set(jsonData, forKey: UserDefaultsManager.key)
    }
    
    func load() throws -> String {
        let userDefaults = UserDefaults.standard
        guard let jsonData = userDefaults.data(forKey: UserDefaultsManager.key) else {
            return "jsonData is nil"
        }
        let text = try JSONDecoder().decode(String.self, from: jsonData)
        return text
    }
}

