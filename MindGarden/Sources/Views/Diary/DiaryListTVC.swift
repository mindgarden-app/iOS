//
//  ListTVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class DiaryListTVC: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dayOfWeekLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    
    var diaryIdx: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLabelEllipsis()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLabelEllipsis() {
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
    }
}
