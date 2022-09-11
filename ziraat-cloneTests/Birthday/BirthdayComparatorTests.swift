//
//  BirthdayComparatorTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/11/22.
//

import XCTest
@testable import ziraat_clone

class BirthdayComparatorTests: XCTestCase {
    var birthday: Date {
        Date.from(year: 1999, month: 2, day: 11)
    }
    
    var birthdayPresent: Date {
        Date.from(year: 2022, month: 2, day: 11)
    }
    
    var aDayDiffersMonth: Date {
        Date.from(year: 2022, month: 6, day: 11)
    }
    
    var aDayDiffersDay: Date {
        Date.from(year: 2022, month: 2, day: 20)
    }
    
    func test_compare_shouldReturnTrue_whenMonthAndDayAreEqual() throws {
        let isBirthday = BirthdayComparator.compare(birthday, birthdayPresent)
        XCTAssertTrue(isBirthday)
    }
    
    func test_compare_shouldReturnFalse_whenDayIsDifferent() throws {
        let isBirthday = BirthdayComparator.compare(birthday, aDayDiffersDay)
        XCTAssertFalse(isBirthday)
    }
    
    func test_compare_shouldReturnFalse_whenMonthIsDifferent() throws {
        let isBirthday = BirthdayComparator.compare(birthday, aDayDiffersMonth)
        XCTAssertFalse(isBirthday)
    }
}
