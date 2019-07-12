//
//  UITableView+Extensions.swift
//  MindGarden
//
//  Created by Sunghee Lee on 11/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setEmptyView() {
        let screenSize: CGRect = UIScreen.main.bounds
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: screenSize.width, height: screenSize.height))
        emptyView.backgroundColor = UIColor.whiteForBorder
        let image: UIImage = UIImage(named: "imgListZero")!
        let emptyImageView = UIImageView(image: image)
        emptyImageView.frame = CGRect(x: 117, y: 225, width: image.size.width, height: image.size.height)
        emptyView.addSubview(emptyImageView)
        
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
