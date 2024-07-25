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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rssFeedTopicsTableView.dataSource = self
        rssFeedTopicsTableView.delegate = self
        rssFeedTopicsTableView.register(
            UINib(nibName: RSSFeedSelectionTableViewCell.cellNibName, bundle: nil),
            forCellReuseIdentifier: RSSFeedSelectionTableViewCell.cellIdentifier
        )
        self.title = "ニュースフィード選択画面"
        let saveButton = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        self.navigationItem.rightBarButtonItem = saveButton
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
    }
}

extension RSSFeedSelectionViewController {
    @objc func saveButtonTapped() {
        
    }
}
