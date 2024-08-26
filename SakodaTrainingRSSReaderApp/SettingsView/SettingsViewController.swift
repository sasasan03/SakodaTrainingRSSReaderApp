//
//  SettingsViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/07/14.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let firebaseClient = FirebaseClient()
    
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
        self.title = "設定画面"
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(didTapCloseButton))
            navigationItem.rightBarButtonItem = closeButton
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
            do {
                try firebaseClient.signOut()
                if self.presentingViewController != nil {
                    self.dismiss(animated: true) {
                        self.popToLoginViewController()
                    }
                }
            } catch {
                print("# firebaseClient.signOut error is : \(error)")
            }
            return
        }
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}


// ログアウトの処理
extension SettingsViewController {
    
    func popToLoginViewController(){
        guard let  windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return print("SettingsViewController：windowScene is nil")
        }
        guard let navigationController = window.rootViewController as? UINavigationController else {
            return print("SettingsViewController：rootViewcontroller is nil.")
        }
        navigationController.popToRootViewController(animated: true)
    }
    
}

// 右上閉じるボタンの処理
extension SettingsViewController {
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
