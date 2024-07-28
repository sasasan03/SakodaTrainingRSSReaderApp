//
//  FeedListViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/14.
//

import UIKit



class FeedListViewController: UIViewController {
    
    let userDefaultsMangaer = UserDefaultsManager.shared
    let yahooRSSFeedRepository = YahooRSSFeedRepository()
    var RSSFeeds:[RSSFeed] = []
    
    @IBOutlet weak var feedListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ニュースフィード画面"
        feedListTableView.dataSource = self
        feedListTableView.delegate = self
        feedListTableView.register(
            UINib(
                nibName: FeedListTableViewCell.cellNibName,
                bundle: nil
            ),
            forCellReuseIdentifier: FeedListTableViewCell.cellIdentifier
        )
        Task {
            do {
                let urls = try getFavoriteTopicURLs()
                let rssFeeds = try await yahooRSSFeedRepository.fetchedRSSFeeds(urls: urls)
                RSSFeeds = rssFeeds
                feedListTableView.reloadData()
            } catch {
                print("💫","エラー『\(error)』")
            }
        }
        
    }
}

extension FeedListViewController {
    
    private func getFavoriteTopicURLs() throws -> [String]{
        guard let topics = userDefaultsMangaer.registeredTopics else {
            throw UserDefaultsError.noRegisteredTopics
        }
        var urls: [String] = []
        for topic in topics {
            let url = topic.url
            urls.append(url)
        }
        return urls
    }
    
    private func getItemTitle(rssFeeds: [RSSFeed]) -> [String] {
        var itemsTitles:[String] = []
        for rssFeed in rssFeeds {
            for item in rssFeed.channel.items {
                itemsTitles.append(item.title)
            }
        }
        return itemsTitles
    }
    
}

extension FeedListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RSSFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedListTableViewCell.cellIdentifier, for: indexPath) as! FeedListTableViewCell
        cell.configureCellContent(rssFeed:RSSFeeds[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feedListTableView.reloadRows(at: [indexPath], with: .automatic)
        let selectedTopic = RSSFeeds[indexPath.row]
    }
}

