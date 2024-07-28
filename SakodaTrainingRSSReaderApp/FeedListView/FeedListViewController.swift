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
    var rssFeedList:[RSSFeed] = []
    var items:[Item] = []
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
                rssFeedList = rssFeeds
                let items = getItems(rssFeeds: rssFeedList)
                self.items = items
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
    
    private func getItems(rssFeeds: [RSSFeed]) -> [Item] {
        var items:[Item] = []
        for rssFeed in rssFeeds {
            for item in rssFeed.channel.items {
                items.append(item)
            }
        }
        return items
    }
    
}

extension FeedListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedListTableViewCell.cellIdentifier, for: indexPath) as! FeedListTableViewCell
        cell.configureCellContent(item: items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var currentIndex = 0
        var selectedFeed: Item?
        for rssFeed in rssFeedList {
            if indexPath.row < currentIndex + rssFeed.channel.items.count {
                selectedFeed = rssFeed.channel.items[indexPath.row - currentIndex]
                break
            }
            currentIndex += rssFeed.channel.items.count
        }
        guard let feed = selectedFeed else { return }
        let articleViewController = ArticleViewController(nibName: "ArticleViewController", bundle: nil)
        articleViewController.article = feed
        navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    
}

