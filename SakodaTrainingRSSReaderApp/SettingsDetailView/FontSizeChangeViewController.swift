//
//  FontSizeChangeViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/08/09.
//

import UIKit

class FontSizeChangeViewController: UIViewController {
    
    var userDefaultsManager = UserDefaultsManager.shared
    let fontSizes: [CGFloat] = [12, 14, 16, 18, 20, 24, 28, 30]
    
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontSizePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontSizePickerView.delegate = self
        fontSizePickerView.dataSource = self
        fontSizeLabel.text = "文字のサイズ"
        fontSizeLabel.font = fontSizeLabel.font.withSize(userDefaultsManager.fontSize)
    }

}

extension FontSizeChangeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontSizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Int(fontSizes[row]))pt"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedFontSize = fontSizes[row]
        userDefaultsManager.fontSize = selectedFontSize
        fontSizeLabel.font = fontSizeLabel.font.withSize(selectedFontSize)
        NotificationCenter.default.post(name: .fontSizeDidChange, object: nil)
    }
    
}
