//
//  ListTVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class ListTVC: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dayOfWeekLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view.setBorder(borderColor: UIColor.gray, borderWidth: 1.0)
        
        dateLabel.sizeToFit()
        dayOfWeekLabel.sizeToFit()
        titleLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
