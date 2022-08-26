//
//  LoginButtonTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 8/23/22.
//

import XCTest
@testable import ziraat_clone

class LoginButtonTests: XCTestCase {
    func test_setBackgroundColor_correctlySetsColorForEnabledState() throws {
        let sut = UIButtonExtended()
        let color: UIColor = .red
        sut.setBackgroundColor(color, for: .enabled)
        
        XCTAssertEqual(sut.enabledBackgroundColor, color)
    }
    
    func test_setBackgroundColor_correctlySetsColorForDisabledState() throws {
        let sut = UIButtonExtended()
        let color: UIColor = .red
        sut.setBackgroundColor(color, for: .disabled)
        
        XCTAssertEqual(sut.disabledBackgroundColor, color)
    }
    
    func test_setsBackgroundColorToEnabledColor_WhenSetEnabledToTrue() throws {
        let sut = UIButtonExtended()
        let color: UIColor = .green
        sut.setBackgroundColor(color, for: .enabled)
        
        sut.isEnabled = true
        
        XCTAssertEqual(sut.backgroundColor, color)
    }
    
    func test_setsBackgroundColorToDisabledColor_WhenSetEnabledToFalse() throws {
        let sut = UIButtonExtended()
        let color: UIColor = .green
        sut.setBackgroundColor(color, for: .disabled)
        
        sut.isEnabled = false
        
        XCTAssertEqual(sut.backgroundColor, color)
    }
    
    func test_enabledPropertyIsInSynchWithBackgroundColor() throws {
       
        let sut = UIButtonExtended()
        let enabledColor: UIColor = .green
        let disabledColor: UIColor = .red
       
        // prepare
        sut.setBackgroundColor(enabledColor, for: .enabled)
        sut.setBackgroundColor(disabledColor, for: .disabled)

        sut.isEnabled = false
        XCTAssertEqual(sut.backgroundColor, disabledColor)
        
        sut.isEnabled = true
        XCTAssertEqual(sut.backgroundColor, enabledColor)
    }

}
