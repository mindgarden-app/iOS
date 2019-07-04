//
//  SettingsWithSwitchTVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 03/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

protocol SwitchDelegate: class {
    func OnSwitch(name: String, isOn: Bool)
}

class SettingsWithSwitchTVC: UITableViewCell {

    @IBOutlet var settingsNameLabel: UILabel!
    @IBOutlet var settingsSwitch: UISwitch!
    
    weak var delegate: SwitchDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initView() {
        settingsSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
    }
    
    func isOn() -> Bool {
        return settingsSwitch!.isOn
    }
    
    func setSwitch() {
        settingsSwitch.isOn = UserDefaults.standard.bool(forKey: settingsNameLabel.text!)
    }
    
    @objc func changeSwitch(_ sender: UISwitch) {
        let name: String = settingsNameLabel.text ?? ""
        let isOn: Bool = settingsSwitch.isOn

        delegate?.OnSwitch(name: name, isOn: isOn)
    }
}
