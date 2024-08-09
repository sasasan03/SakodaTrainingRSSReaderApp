//
//  SettingsViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/14.
//

import UIKit

class SettingsViewController: UIViewController {
    
    enum SettingsOption: String, CaseIterable {
        case toggleListView = "一覧画面の表示切り替え"
        case rssInterval = "RSS取得間隔"
        case manageRss = "購読RSS管理"
        case changeFontSize = "文字サイズ変更"
        case darkMode = "ダークモード"
        case logout = "ログアウト"
    }
    
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
        return SettingsOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.cellIdentifier,
            for: indexPath
        ) as! SettingsTableViewCell
        cell.configureCellContent(text: SettingsOption.allCases[indexPath.row].rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectItem = SettingsOption.allCases[indexPath.row]
        
        let destinationVC: UIViewController
        switch selectItem {
        case .toggleListView:
            destinationVC = ToggleListViewController()
        case .rssInterval:
            destinationVC = RssIntervalViewController()
        case .manageRss:
            destinationVC = ManageRssViewController()
        case .changeFontSize:
            destinationVC = FontSizeChangeViewController()
        case .darkMode:
            destinationVC = DarkModeViewController()
        case .logout:
            //TODO: このセルをタップしたら、即ログアウトさせる関数を作成する
            logout()
            return
        }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func logout(){
        print("#ログアウトしました。（実際はされていない。後に実装）")
    }
}
