//
//  SettingsTableViewCell.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/08/03.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let cellNibName = "SettingsTableViewCell"
    static let cellIdentifier = "SettingsViewCell"
    var userDefaultsManager = UserDefaultsManager.shared
    
    @IBOutlet weak var itemText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //.fontSizeDidChangeの変更を通知してもらえるよう設定
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFontSize),
            name: .fontSizeDidChange,
            object: nil
        )
        // 保存されている文字サイズに合わせて文字の大きさが変更される
        itemText.font = itemText.font.withSize(userDefaultsManager.fontSize)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .fontSizeDidChange, object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellContent(text: String){
        itemText.text = text
    }
    
}

extension SettingsTableViewCell {
    // 保存されている文字のサイズをラベルに反映させる
    @objc func updateFontSize() {
        let updatedFontSize = userDefaultsManager.fontSize
        itemText.font = itemText.font.withSize(updatedFontSize)
    }
    
}
