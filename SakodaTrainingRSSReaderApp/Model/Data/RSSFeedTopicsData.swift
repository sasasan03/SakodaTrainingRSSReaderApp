//
//  RSSFeedTopicsData.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/24.
//

import Foundation

struct RSSFeedTopicsData {
    let topicsData = [
        Topic(title: "主要", url: "https://news.yahoo.co.jp/rss/topics/top-picks.xml", isChecked: false),
        Topic(title: "国内", url: "https://news.yahoo.co.jp/rss/media/domestic.xml", isChecked: false),
        Topic(title: "国際", url: "https://news.yahoo.co.jp/rss/media/international.xml", isChecked: false),
        Topic(title: "経済", url: "https://news.yahoo.co.jp/rss/media/economy.xml", isChecked: false),
        Topic(title: "エンタメ", url: "https://news.yahoo.co.jp/rss/media/entertainment.xml", isChecked: false),
        Topic(title: "スポーツ", url: "https://news.yahoo.co.jp/rss/media/sports.xml", isChecked: false),
        Topic(title: "IT", url: "https://news.yahoo.co.jp/rss/media/it.xml", isChecked: false),
        Topic(title: "科学", url: "https://news.yahoo.co.jp/rss/media/science.xml", isChecked: false)
    ]

}
