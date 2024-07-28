//
//  RSSFeedTopicsDataSource.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/22.
//

import Foundation

class RSSFeedTopicsData {
    let topicsData = [
        Topic(title: "主要", url: "https://news.yahoo.co.jp/rss/topics/top-picks.xml"),
        Topic(title: "国内", url: "https://news.yahoo.co.jp/rss/media/domestic.xml"),
        Topic(title: "国際", url: "https://news.yahoo.co.jp/rss/media/international.xml"),
        Topic(title: "経済", url: "https://news.yahoo.co.jp/rss/media/economy.xml"),
        Topic(title: "エンタメ", url: "https://news.yahoo.co.jp/rss/media/entertainment.xml"),
        Topic(title: "スポーツ", url: "https://news.yahoo.co.jp/rss/media/sports.xml"),
        Topic(title: "IT", url: "https://news.yahoo.co.jp/rss/media/it.xml"),
        Topic(title: "科学", url: "https://news.yahoo.co.jp/rss/media/science.xml")
    ]
}

struct Topic: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let url: String
}
