//
//  Date+Extensions.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

extension Date {
    
    func getDayOfTheWeek() -> String? {
        let weekdays = [
            "일",
            "월",
            "화",
            "수",
            "목",
            "금",
            "토"
        ]
        
        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
}
