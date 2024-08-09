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
    
    @IBOutlet weak var itemText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellContent(text: String){
        itemText.text = text
    }
    
}
