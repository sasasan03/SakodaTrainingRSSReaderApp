//
//  DarkModeViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/08/09.
//

import UIKit

class DarkModeViewController: UIViewController {
    
    let userDefaults = UserDefaultsManager.shared
    @IBOutlet weak var darkModeSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeSwitch.isOn = userDefaults.loadInterfaceStyle()
    }
    
    @IBAction func switchAppearance(_ sender: UISwitch) {
        
        let style: UIUserInterfaceStyle = sender.isOn ? .dark : .light
        let styleRawValue = style.rawValue
        userDefaults.saveDarkModePreference(style: styleRawValue)
        userDefaults.saveInterfaceStyle(isOn: darkModeSwitch.isOn)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.setAppAppearance(to: style)
        }
        
    }

}
