//
//  ProfileTVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 02/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class ProfileTVC: UITableViewCell {

    @IBOutlet var profileCell: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var typeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        typeView.makeRounded(cornerRadius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
