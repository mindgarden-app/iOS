//
//  Date+Extensions.swift
//  MindGarden
//
//  Created by Sunghee Lee on 01/07/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

enum DateFormatType: String {
    /// Time
    case time = "HH:mm:ss"
    
    /// Date with hours
    case dateWithTime = "dd-MMM-yyyy  H:mm"
    
    /// Date
    case date = "dd-MMM-yyyy"
}

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
    
    func converToString(dateformat formatType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue
        let newDate: String = dateFormatter.string(from: self)
        
        return newDate
    }
}
