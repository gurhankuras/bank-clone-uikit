//
//  LocalizationViewModelTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import XCTest
@testable import ziraat_clone

class LocalizationViewModelTests: XCTestCase {
    func test_selectedLanguage_informsAnyLanguageListenersAndUsesService() throws {
        // Arrange
        let spy = LocalizationServiceSpy()
        let sut = LocalizationViewModel(languageService: spy)

        var currentLanguage: LocalizationLanguage?
        sut.didSelectLanguage = { currentLanguage = $0 }
        
        // Act
        sut.selectedLanguage = .en

        // Assert
        XCTAssertNotNil(currentLanguage)
        XCTAssertEqual(currentLanguage, .en)
        XCTAssertEqual(spy.appliedCount, 1)
        XCTAssertEqual(spy.languageChanges, [.en])
        
        // Act
        sut.selectedLanguage = .tr
        
        // Assert
        XCTAssertNotNil(currentLanguage)
        XCTAssertEqual(currentLanguage, .tr)
        XCTAssertEqual(spy.appliedCount, 2)
        XCTAssertEqual(spy.languageChanges, [.en, .tr])
    }
}

class LocalizationServiceSpy: LocalizationService {
    
    var currentLanguage: LocalizationLanguage = .en
    
    private(set) var appliedCount = 0
    private(set) var languageChanges: [LocalizationLanguage] = []
   
    func applyCurrent() {
        appliedCount += 1
    }
    
    func set(to newLanguage: LocalizationLanguage) {
        languageChanges.append(newLanguage)
    }
}
