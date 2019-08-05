//
//  NSMutableAttributedString+Extension.swift
//  MindGarden
//
//  Created by Sunghee Lee on 05/08/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "NotoSansCJKkr-Medium", size: 14)!, .foregroundColor: UIColor(white: 43.0 / 255.0, alpha: 1.0)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "NotoSansCJKkr-Regular", size: 14)!, .foregroundColor: UIColor(white: 43.0 / 255.0, alpha: 1.0)]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)
        
        return self
    }
}
