//
//  AppLanguageServiceTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import XCTest
@testable import ziraat_clone

class AppLanguageServiceTests: XCTestCase {
    // MARK: currentLanguage
    func test_currentLanguage_presentsUserSelectedLanguage_whenUserExplicitlyChangedLanguage() throws {
        // Arrange
        let store = LocalizationFakeUserDefaults()
        let fallbackLanguage = LocalizationLanguage.tr
        let sut = LanguageService(keyValueStore: store, fallbackLanguage: fallbackLanguage)
        
        let selectedLanguage = LocalizationLanguage.en
        sut.set(to: selectedLanguage)
        
        // Act
        let currentLanguage = sut.currentLanguage
        
        // Assert
        XCTAssertNotNil(currentLanguage)
        XCTAssertEqual(currentLanguage, selectedLanguage)
    }
    
    func test_currentLanguage_presentsFirstSystemLanguage_ifUserDidNotSelectLanguageAndSystemLanguagesFound() throws {
        // Arrange
        let store = LocalizationFakeUserDefaults()
        let fallbackLanguage = LocalizationLanguage.tr
        let sut = LanguageService(keyValueStore: store, fallbackLanguage: fallbackLanguage)
        store.returns(appleLanguages: [.en, .tr])
        
        // Act
        let currentLanguage = sut.currentLanguage
        
        // Assert
        XCTAssertNotNil(currentLanguage)
        XCTAssertEqual(currentLanguage, .en)
    }
    
    func test_currentLanguage_presentsFallbackLanguageToUser_unlessUserExplicitlyChangePreference() throws {
        // Arrange
        let store = LocalizationFakeUserDefaults()
        let fallbackLanguage = LocalizationLanguage.tr
        let sut = LanguageService(keyValueStore: store, fallbackLanguage: fallbackLanguage)
        
        // Act
        let currentLanguage = sut.currentLanguage
        
        // Assert
        XCTAssertNotNil(currentLanguage)
        XCTAssertEqual(currentLanguage, fallbackLanguage)
    }
}

extension AppLanguageServiceTests {
    func test_set_changesUserPreferredLanguage() throws {
        // Arrange
        let store = LocalizationFakeUserDefaults()
        let fallbackLanguage = LocalizationLanguage.tr
        let sut = LanguageService(keyValueStore: store, fallbackLanguage: fallbackLanguage)
        
        // Act
        sut.set(to: .en)
        
        XCTAssertEqual(sut.currentLanguage, .en)
    }
}
