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
    var userDefaultsManager = UserDefaultsManager.shared
    
    @IBOutlet weak var feedText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(
            self,
            selector:  #selector(updateFontSize),
            name: .fontSizeDidChange,
            object: nil
        )
        // 保存されている文字サイズに合わせて文字の大きさが変更される
        feedText.font = feedText.font.withSize(userDefaultsManager.fontSize)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .fontSizeDidChange, object: nil)
    }
    
}

extension FeedListTableViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellContent(item: Item){
        let title  = item.title
        feedText.text = title
    }
    
}

extension FeedListTableViewCell {
    
    @objc func updateFontSize() {
        let updatedFontSize = userDefaultsManager.fontSize
        feedText.font = feedText.font.withSize(updatedFontSize)
    }
    
}
