//
//  TopicEntity.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/23.
//

import Foundation

struct Topic: Codable, Identifiable, Equatable {
    var id = UUID()
    let title: String
    let url: String
    var isChecked: Bool
}
