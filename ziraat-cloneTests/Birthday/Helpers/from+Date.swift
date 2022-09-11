//
//  from+Date.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/11/22.
//

import Foundation
extension Date {
    static func from(year: Int, month: Int, day: Int) -> Self {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        guard let date = Calendar.current.date(from: dateComponents) else {
            fatalError("Couldnt create date!")
        }
        let startOfDay = Calendar.current.startOfDay(for: date)
        return startOfDay
    }
}
