//
//  RSSFeedSelectionViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/07.
//

import UIKit

class RSSFeedSelectionViewController: UIViewController {
    
    let rssFeedTopicsData = RSSFeedTopicsData()
    var dataSource:[Topic] = []
    var selectedTopics: [Topic] = []
    @IBOutlet weak var rssFeedTopicsTableView: UITableView!
    
    @IBAction func didTapSelectNewsFeedSave(_ sender: Any) {
        let feedListVC = FeedListViewController()
        feedListVC.title = "YahooNewsFeed一覧"
        let navigationViewController = UINavigationController(rootViewController: feedListVC)
        navigationViewController.pushViewController(navigationViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        rssFeedTopicsTableView.dataSource = self
        rssFeedTopicsTableView.delegate = self
        rssFeedTopicsTableView.register(
            UINib(nibName: RSSFeedSelectionTableViewCell.cellNibName, bundle: nil),
            forCellReuseIdentifier: RSSFeedSelectionTableViewCell.cellIdentifier
        )
        dataSource = rssFeedTopicsData.topicsData
        rssFeedTopicsTableView.reloadData()
    }
}

extension RSSFeedSelectionViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RSSFeedSelectionTableViewCell.cellIdentifier, for: indexPath) as! RSSFeedSelectionTableViewCell
        cell.configureCellContent(title: dataSource[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedTopic = dataSource[indexPath.row]
            
            if let index = selectedTopics.firstIndex(of: selectedTopic) {
                selectedTopics.remove(at: index)
            } else {
                selectedTopics.append(selectedTopic)
            }
            for topic in selectedTopics {
                print("----------------")
                print("Selected Topic: \(topic.title)")
            }
        }
}
