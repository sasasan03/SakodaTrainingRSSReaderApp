//
//  YahooRSSFeedRepository.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/10.
//

import Foundation

final class YahooRSSFeedRepository {
    let dataStore: RSSFetcherRepositoryProtocol?
    
    init(rssFetcherProtocol: RSSFetcherRepositoryProtocol? = RSSFeedFetcher()) {
        self.dataStore = rssFetcherProtocol
    }
    
    func fetchFeed(url: String) async throws -> RSSFeed? {
        guard let dataStore else {
            throw RSSFeedError.rssFetchError
        }
        return try await dataStore.fetchFeed(url: url)
    }
}
