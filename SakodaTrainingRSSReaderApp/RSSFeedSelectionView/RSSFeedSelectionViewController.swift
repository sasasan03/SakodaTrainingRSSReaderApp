//
//  RSSFeedSelectionViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/07.
//

import UIKit

class RSSFeedSelectionViewController: UIViewController {
    
    @IBOutlet weak var rssFeedTopicsTableView: UITableView!
    
    let dataSource = ["りんご","ぶどう","なし","みかん"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rssFeedTopicsTableView.dataSource = self
        rssFeedTopicsTableView.delegate = self
        rssFeedTopicsTableView.register(
            UINib(nibName: RSSFeedSelectionTableViewCell.cellNibName, bundle: nil),
            forCellReuseIdentifier: RSSFeedSelectionTableViewCell.cellIdentifier
        )
    }
}

extension RSSFeedSelectionViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RSSFeedSelectionTableViewCell.cellIdentifier, for: indexPath) as! RSSFeedSelectionTableViewCell
        cell.configureCellContent()
        return cell
    }
    
    
}
