//
//  SettingsWithSwitchTVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 03/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class SettingsWithSwitchTVC: UITableViewCell {

    @IBOutlet var settingsNameLabel: UILabel!
    @IBOutlet var settingsSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
