//
//  FeedListViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/14.
//

import UIKit

class FeedListViewController: UIViewController {
    
    let userDefaultsManager = UserDefaultsManager.shared
    let yahooRSSFeedRepository = YahooRSSFeedRepository()
    var rssFeedList:[RSSFeed] = []
    var items:[Item] = []
    var topics:[Topic]
    
    init(topics: [Topic]){
        self.topics = topics
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var feedListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ニュースフィード一覧"
        // 『edit』ボタン
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
        // tableViewとcellの設定
        feedListTableView.dataSource = self
        feedListTableView.delegate = self
        feedListTableView.register(
            UINib(
                nibName: FeedListTableViewCell.cellNibName,
                bundle: nil
            ),
            forCellReuseIdentifier: FeedListTableViewCell.cellIdentifier
        )
        // 左上バックボタンを非表示
        self.navigationItem.hidesBackButton = true
        // セレクト画面で選択されたニュースフィードを取得してくる。
        Task {
            do {
                let urls = try getFavoriteTopicURLs(topics: self.topics)
                let rssFeeds = try await yahooRSSFeedRepository.fetchedRSSFeeds(urls: urls)
                rssFeedList = rssFeeds
                let items = getItems(rssFeeds: rssFeedList)
                self.items = items
                feedListTableView.reloadData()
            } catch {
                print("💫FeedListError","エラー『\(error)』")
            }
        }
        //.fontSizeDidChangeの変更を通知してもらえるよう設定
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadTableView),
            name: .fontSizeDidChange,
            object: nil
        )
        // Cellのオートレイアウト
        self.feedListTableView.estimatedRowHeight = 50
        self.feedListTableView.rowHeight = UITableView.automaticDimension
    }
    
}

extension FeedListViewController {
    //通知を受けるとtableViewがリロードされる。これがないと、文字サイズが変更されていても、Cellのオートレイアウトが効かない。
    @objc func reloadTableView() {
        feedListTableView.reloadData()
    }
}

extension FeedListViewController {
    
    private func getFavoriteTopicURLs(topics: [Topic]) throws -> [String]{
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
    
    @objc func editButtonTapped() {
        let settingsVC = SettingsViewController()
        let navigationViewController = UINavigationController(rootViewController: settingsVC)
        navigationViewController.modalPresentationStyle = .automatic
        self.present(navigationViewController, animated: true)
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
        articleViewController.urlString = feed.link
        navigationController?.pushViewController(articleViewController, animated: true)
    }
    
}

