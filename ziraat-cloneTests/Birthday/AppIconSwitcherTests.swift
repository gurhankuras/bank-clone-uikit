//
//  AppIconSwitcherTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/9/22.
//

import XCTest
@testable import ziraat_clone

class AppIconSwitcherTests: XCTestCase {
    struct DummyError: Error {}
    
    func test_callsCompletionWhenSuccess() throws {
        let changer = AlternateIconChangerStub(error: nil)
        let sut = AppIconManager(changer: changer, keyValueStore: FakeUserDefaults())
        var calledCount = 0
        sut.switch(to: .normal, completion: {_ in calledCount += 1 })
        
        XCTAssertEqual(calledCount, 1)
    }
    
    func test_callsCompletionWhenError() throws {
        let changer = AlternateIconChangerStub(error: DummyError())
        let sut = AppIconManager(changer: changer, keyValueStore: FakeUserDefaults())
        var calledCount = 0
        sut.switch(to: .normal, completion: {_ in calledCount += 1 })
        
        XCTAssertEqual(calledCount, 1)
    }
    
    func test_persistsCurrentIcon() throws {
        let changer = AlternateIconChangerStub(error: nil)
        let store = FakeUserDefaults()
        let sut = AppIconManager(changer: changer, keyValueStore: store)

        sut.switch(to: .normal, completion: {_ in })
        XCTAssertEqual(store.strings[AppIconManager.iconKey], AppIcon.normal.rawValue)
        
        sut.switch(to: .birthday, completion: {_ in })
        XCTAssertEqual(store.strings[AppIconManager.iconKey], AppIcon.birthday.rawValue)
    }
    
    func test_currentIcon_shouldReturnNormalIconFirstTime() throws {
        let store = FakeUserDefaults()
        let sut = AppIconManager(changer: AlternateIconChangerStub(error: nil), keyValueStore: store)
        
        let icon = sut.currentIcon
        
        XCTAssertEqual(icon, .normal)
    }
    
    func test_currentIcon_shouldReturnBirthdayIconOnBirthday() throws {
        let store = FakeUserDefaults()
        let sut = AppIconManager(changer: AlternateIconChangerStub(error: nil), keyValueStore: store)
        
        sut.switch(to: .birthday, completion: {_ in })
        
        let icon = sut.currentIcon
        
        XCTAssertEqual(icon, .birthday)
    }
    
    func test_currentIcon_shouldReturnNormalIcon_afterPassedBirthdayFirstTime() throws {
        let store = FakeUserDefaults()
        let sut = AppIconManager(changer: AlternateIconChangerStub(error: nil), keyValueStore: store)
        
        sut.switch(to: .normal, completion: {_ in })
        
        let icon = sut.currentIcon
        
        XCTAssertEqual(icon, .normal)
    }
    
    func test_currentIcon_shouldCrash_afterPassedBirthdayFirstTime() throws {
        let store = FakeUserDefaults()
        store.set("DoesNotExist", forKey: AppIconManager.iconKey)
        let sut = AppIconManager(changer: AlternateIconChangerStub(error: nil), keyValueStore: store)
                
        expectFatalError(expectedMessage: "Invalid app icon. This is likely a developer mistake.") {
            _ = sut.currentIcon
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
