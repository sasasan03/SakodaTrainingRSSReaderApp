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
        Topic(title: "国内", url: "https://news.yahoo.co.jp/rss/topics/domestic.xml", isChecked: false),
        Topic(title: "国際", url: "https://news.yahoo.co.jp/rss/topics/world.xml", isChecked: false),
        Topic(title: "経済", url: "https://news.yahoo.co.jp/rss/topics/business.xml", isChecked: false),
        Topic(title: "エンタメ", url: "https://news.yahoo.co.jp/rss/topics/entertainment.xml", isChecked: false),
        Topic(title: "スポーツ", url: "https://news.yahoo.co.jp/rss/topics/sports.xml", isChecked: false),
        Topic(title: "IT", url: "https://news.yahoo.co.jp/rss/topics/it.xml", isChecked: false),
        Topic(title: "科学", url: "https://news.yahoo.co.jp/rss/topics/science.xml", isChecked: false),
        Topic(title: "地域", url: "https://news.yahoo.co.jp/rss/topics/local.xml", isChecked: false)
    ]

}
