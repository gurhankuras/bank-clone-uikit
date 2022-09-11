//
//  BirthdayCelebratorTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/9/22.
//

import XCTest
@testable import ziraat_clone

class BirthdayAppIconProcessorTests: XCTestCase {

    var aDay: Date {
        Date.from(year: 2022, month: 6, day: 20)
    }
    
    func test_process_switchesToBirthdayIcon_whenTheDayBirthdayAndIconIsNormal() throws {
        let spy = AppIconManagerSpy(currentIcon: nil, error: nil)
        let sut = BirthdayAppIconProcessor(iconManager: spy,
                                           comparator: {_, _ in true},
                                           timeProvider: { self.aDay })
        
        sut.process(birthdayOf: .stub)
        
        XCTAssertEqual(spy.icons.count, 1)
        XCTAssertEqual(spy.icons.first, .birthday)
    }
    
    func test_process_switchesToNormalIcon_whenNotBirthdayAndIconIsBirthdayIcon() throws {
        let spy = AppIconManagerSpy(currentIcon: .birthday, error: nil)
        let sut = BirthdayAppIconProcessor(iconManager: spy,
                                           comparator: {_, _ in false },
                                           timeProvider: { self.aDay })
        sut.process(birthdayOf: .stub)
        
        XCTAssertEqual(spy.icons.count, 1)
        XCTAssertEqual(spy.icons.first, .normal)
    }
    
    func test_process_doesNotSwitchesToBirthdayIcon_WhenTheDayIsBirthdayAndBirthdayIconIsAlreadyInPlace() throws {
        let spy = AppIconManagerSpy(currentIcon: .birthday, error: nil)
        let sut = BirthdayAppIconProcessor(iconManager: spy,
                                           comparator: { _, _ in true },
                                           timeProvider: { self.aDay })
        sut.process(birthdayOf: .stub)
        
        XCTAssertEqual(spy.icons.count, 0)
    }
    
    func test_process_doesNotSwitchesToNormalIcon_WhenNotBirthdayAndNormalIconIsAlreadyInPlace() throws {
        let spy = AppIconManagerSpy(currentIcon: .normal, error: nil)
        let sut = BirthdayAppIconProcessor(iconManager: spy,
                                           comparator: {_, _ in false },
                                           timeProvider: { self.aDay })
        
        sut.process(birthdayOf: .stub)
        
        XCTAssertEqual(spy.icons.count, 0)
    }
}
