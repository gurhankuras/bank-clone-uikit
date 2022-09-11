//
//  BirthdayComparator.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/11/22.
//

import Foundation

enum BirthdayComparator {
    static func compare(_ lhs: Date, _ rhs: Date) -> Bool {
        let calendar = Calendar.current
        let leftComponents = startDayComponents(of: lhs, on: calendar)
        let rightComponents = startDayComponents(of: rhs, on: calendar)
        
        guard let leftMonth = leftComponents.month,
              let leftDay = leftComponents.day,
              let rightMonth = rightComponents.month,
              let rightDay = rightComponents.day else {
            fatalError("Error")
        }
        
        return (leftMonth, leftDay) == (rightMonth, rightDay)
    }
    
    private static func startDayComponents(of date: Date, on calendar: Calendar) -> DateComponents {
        let startOfDay = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day, .month], from: startOfDay)
        return components
    }
}

/*
 
 let userBirthday = Calendar.current.startOfDay(for: user.birthDate)
 let now = Calendar.current.startOfDay(for: timeProvider())
 
 let formatter = DateFormatter()
 formatter.dateFormat = "dd/MM"
 
 return formatter.string(from: userBirthday) == formatter.string(from: now)
 */
