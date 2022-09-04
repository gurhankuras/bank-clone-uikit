//
//  LocalizationFakeUserDefaults.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation
@testable import ziraat_clone

class LocalizationFakeUserDefaults: FakeUserDefaults {
    private var appleLanguages: [String] = []
    
    override func stringArray(forKey defaultName: String) -> [String]? {
        if defaultName == LanguageService.Keys.systemLanguages.rawValue {
            return appleLanguages
        }
        return super.stringArray(forKey: defaultName)
    }
    func returns(appleLanguages: [LocalizationLanguage]) {
        self.appleLanguages = appleLanguages.map(\.rawValue)
    }
}
