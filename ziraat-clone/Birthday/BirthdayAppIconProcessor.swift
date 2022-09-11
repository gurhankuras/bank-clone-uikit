//
//  BirthdayAppIconProcessor.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/11/22.
//

import Foundation

class BirthdayAppIconProcessor: BirthdayProcessing {
    typealias BirthdayComparatorCallback = (Date, Date) -> Bool

    let today: () -> Date
    let iconManager: AppIconManaging
    let comparator: BirthdayComparatorCallback

    init(iconManager: AppIconManaging, comparator: @escaping BirthdayComparatorCallback, timeProvider: @escaping () -> Date) {
        self.today = timeProvider
        self.comparator = comparator
        self.iconManager = iconManager
    }

    func process(birthdayOf user: AccountHolder) {
        let currentIcon = iconManager.currentIcon
        let isBirthDay = comparator(user.birthDate, today())
        if  currentIcon == .birthday && !isBirthDay {
            iconManager.switch(to: .normal, completion: {_ in })
        } else if currentIcon != .birthday && isBirthDay {
            iconManager.switch(to: .birthday, completion: {_ in })
        }
    }
}
