//
//  LockCodeCVC.swift
//  MindGarden
//
//  Created by Sunghee Lee on 03/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class LockCodeCVC: UICollectionViewCell {

    @IBOutlet var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        codeLabel.makeRounded(cornerRadius: 30
        )
    }

}
