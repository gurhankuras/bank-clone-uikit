//
//  FactoryTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 8/22/22.
//

import XCTest
@testable import ziraat_clone

class FactoryTests: XCTestCase {
    func test_makeHomeViewController_setsCallbacks() throws {
        let vc = Factory.makeHomeViewController(onExit: {}) as! HomePageViewController
        XCTAssertNotNil(vc.onExit)
    }
    
    func test_makeLandingViewController_setsCallbacks() throws {
        let vc = Factory.makeLandingViewController {}
        XCTAssertNotNil(vc.onLoginPressed)
    }
    
    func test_makeLoginViewController_setsCallbacks() throws {
        let vc = Factory.makeLoginViewController(onClose: {}, onLoginButtonPressed: {}) as! LoginViewController
        XCTAssertNotNil(vc.onLogin)
        XCTAssertNotNil(vc.onClose)
        XCTAssertNotNil(vc.viewModel)
    }
}
