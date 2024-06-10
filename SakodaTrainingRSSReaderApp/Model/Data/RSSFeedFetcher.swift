//
//  RSSFeedFetcher.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/10.
//

import Foundation
import XMLCoder

protocol RSSFetcherRepositoryProtocol {
    func fetchFeed(url: String) async throws -> RSSFeed?
}

struct RSSFeedFetcher: RSSFetcherRepositoryProtocol {
    func fetchFeed(url: String) async throws -> RSSFeed? {
        do {
            guard let url = URL(string: url) else { throw RSSFeedError.invalidURL }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedFeed = try XMLDecoder().decode(RSSFeed.self, from: data)
            return decodedFeed
        } catch {
            throw RSSFeedError.rssFetchError
        }
    }
}
