//
//  SettingsViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/14.
//

import UIKit

class SettingsViewController: UIViewController {

    private let items = [
        "一覧画面の表示切り替え",
        "RSS取得間隔",
        "購読RSS管理",
        "文字サイズ変更",
        "ダークモード",
        "ログアウト"
    ]
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(
            UINib(nibName: SettingsTableViewCell.cellNibName, bundle: nil),
            forCellReuseIdentifier: SettingsTableViewCell.cellIdentifier
        )
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.cellIdentifier,
            for: indexPath
        ) as! SettingsTableViewCell
        cell.configureCellContent(text: items[indexPath.row])
        return cell
    }
    
}
