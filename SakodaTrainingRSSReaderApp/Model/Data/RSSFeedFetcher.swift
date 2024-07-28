//
//  RSSFeedFetcher.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/06/10.
//

import Foundation
import XMLCoder

protocol RSSFetcherRepositoryProtocol {
    func fetchedRSSFeeds(urls: [String]) async throws -> [RSSFeed]
}

struct RSSFeedFetcher: RSSFetcherRepositoryProtocol {
    
    func fetchedRSSFeeds(urls: [String]) async throws -> [RSSFeed] {
        var fetchedFeeds:[RSSFeed] = []
        do {
            for url in urls {
                guard let url = URL(string: url) else { throw RSSFeedError.invalidURL }
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedFeed = try XMLDecoder().decode(RSSFeed.self, from: data)
                fetchedFeeds.append(decodedFeed)
            }
            return fetchedFeeds
        } catch let error as RSSFeedError {
            throw error
        } catch let error as DecodingError {
            throw RSSFeedError.decodeError(error)
        } catch {
            throw RSSFeedError.networkError(error)
        }
    }
}
