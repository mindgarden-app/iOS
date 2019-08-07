//
//  String+Extensions.swift
//  MindGarden
//
//  Created by Sunghee Lee on 06/08/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

public extension String {
    
    public func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }

    public func validatePassword() -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[0-9]).{8,16}$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
}
