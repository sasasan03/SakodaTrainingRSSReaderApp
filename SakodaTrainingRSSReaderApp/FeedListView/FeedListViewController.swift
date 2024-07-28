//
//  FeedListViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/14.
//

import UIKit

class FeedListViewController: UIViewController {
    
    let userDefaultsMangaer = UserDefaultsManager.shared
    var dataSource:[Topic] = []
    @IBOutlet weak var feedListTableView: UITableView!
    let yahooRSSFeedRepository = YahooRSSFeedRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            _ = try await yahooRSSFeedRepository.fetchFeed(url: "https://news.yahoo.co.jp/rss/topics/top-picks.xml")
        }
        dataSource = userDefaultsMangaer.registeredTopics ?? []
        feedListTableView.dataSource = self
        feedListTableView.delegate = self
        self.title = "ニュースフィード画面"
        feedListTableView.reloadData()
    }
}

extension FeedListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedListTableViewCell.cellIdentifier, for: indexPath) as! FeedListTableViewCell
        cell.configureCellContent(topic: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource[indexPath.row].isChecked.toggle()
        feedListTableView.reloadRows(at: [indexPath], with: .automatic)
        let selectedTopic = dataSource[indexPath.row]
    }
}

