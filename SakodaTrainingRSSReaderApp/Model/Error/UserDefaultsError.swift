//
//  UserDefaultsError.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/26.
//

import Foundation

enum UserDefaultsError: Error {
    case encodingFailed
    case decodingFailed
    case dataNotFound
    case noRegisteredTopics
    case styleKeyNotFound
    case invalidStyleValue
    case invalidData
}
