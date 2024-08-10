//
//  DarkModeViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/08/09.
//

import UIKit

class DarkModeViewController: UIViewController {
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeSwitch.isOn = false
    }
    
    @IBAction func switchAppearance(_ sender: UISwitch) {
        
        let style: UIUserInterfaceStyle = sender.isOn ? .dark : .light
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.setAppAppearance(to: style)
        }
        
    }

}
