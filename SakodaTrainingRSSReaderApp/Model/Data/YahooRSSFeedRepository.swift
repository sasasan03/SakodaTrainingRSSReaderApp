//
//  YahooRSSFeedRepository.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/10.
//

import Foundation

final class YahooRSSFeedRepository {
    let dataStore: RSSFetcherRepositoryProtocol?
    var fetchedFeeds: [RSSFeed] = []
    
    init(rssFetcherProtocol: RSSFetcherRepositoryProtocol? = RSSFeedFetcher()) {
        self.dataStore = rssFetcherProtocol
    }
    
    func fetchedRSSFeeds(urls: [String]) async throws -> [RSSFeed] {
        guard let dataStore else {
            throw RSSFeedError.rssFetchError
        }
        let fetchedRSSFeed = try await dataStore.fetchedRSSFeeds(urls: urls)
        self.fetchedFeeds = fetchedRSSFeed
        return self.fetchedFeeds
    }
}
