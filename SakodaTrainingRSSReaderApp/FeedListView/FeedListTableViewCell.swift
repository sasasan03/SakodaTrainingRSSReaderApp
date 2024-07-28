//
//  FeedListTableViewCell.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/26.
//

import UIKit

class FeedListTableViewCell: UITableViewCell {
    
    static let cellNibName = "FeedListTableViewCell"
    static let cellIdentifier = "FeedListCell"
    
    @IBOutlet weak var feedText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellContent(rssFeed: RSSFeed){
        feedText.text = rssFeed.channel.title
    }
    
}
