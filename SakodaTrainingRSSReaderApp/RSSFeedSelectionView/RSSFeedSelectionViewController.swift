//
//  RSSFeedSelectionViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/07.
//

import UIKit

class RSSFeedSelectionViewController: UIViewController {
    
    @IBOutlet weak var rssFeedTopicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rssFeedTopicsTableView.dataSource = self
        rssFeedTopicsTableView.delegate = self
    }
}

extension RSSFeedSelectionViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
