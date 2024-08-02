//
//  RSSFeedSelectionViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/07.
//

import UIKit

// TODO: Topicsが選択されずにsaveボタンが押された場合にエラー出すようにする
class RSSFeedSelectionViewController: UIViewController {
    
    let rssFeedTopicsData = RSSFeedTopicsData()
    let userDefaultsManager = UserDefaultsManager.shared
    var dataSource:[Topic] = []
    var selectedTopics: [Topic] = []
    var userID: UserID?
    
    @IBOutlet weak var rssFeedTopicsTableView: UITableView!
    
    init(userID: UserID){
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rssFeedTopicsTableView.dataSource = self
        rssFeedTopicsTableView.delegate = self
        rssFeedTopicsTableView.register(
            UINib(nibName: RSSFeedSelectionTableViewCell.cellNibName, bundle: nil),
            forCellReuseIdentifier: RSSFeedSelectionTableViewCell.cellIdentifier
        )
        // バックボタンを非表示にする
        self.navigationItem.hidesBackButton = true
        self.title = "ニュースフィード選択画面"
        let saveButton = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveAndTransitionButtonTapped)
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
        cell.configureCellContent(topic: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource[indexPath.row].isChecked.toggle()
        rssFeedTopicsTableView.reloadRows(at: [indexPath], with: .automatic)
        let selectedTopic = dataSource[indexPath.row]
        if let index = selectedTopics.firstIndex(of: selectedTopic) {
            selectedTopics.remove(at: index)
        } else {
            selectedTopics.append(selectedTopic)
        }
    }
}

extension RSSFeedSelectionViewController {
    @objc func saveAndTransitionButtonTapped() {
        guard let userID = self.userID else { return print("#userID nil")}
        // TODO: リファクタリングでFirebaseに保存できるように仕様を変更する
        do {
            try userDefaultsManager.saveTopics(topic: selectedTopics)
            try userDefaultsManager.saveUserId(userID: userID)
        } catch {
            print("💫FeedSelectionView Error：",error.localizedDescription)
        }
        let feedListViewController = FeedListViewController(topics: selectedTopics)
        navigationController?.pushViewController(feedListViewController, animated: true)
    }
}
