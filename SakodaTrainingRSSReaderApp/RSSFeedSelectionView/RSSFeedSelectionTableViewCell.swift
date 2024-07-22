//
//  RSSFeedSelectionTableViewCell.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/18.
//

import UIKit

class RSSFeedSelectionTableViewCell: UITableViewCell {
    
    static let cellNibName = "RSSFeedSelectionTableViewCell"
    static let cellIdentifier = "RssTopicCell"

    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var rssTopicText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureCellContent(title: String){
        checkMark.image = UIImage(systemName: "checkmark.square")
        rssTopicText.text = title
    }
}
