//
//  AppLanguage.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/27/22.
//

import Foundation

class LanguageService: LocalizationService {
    
    private let fallback: LocalizationLanguage
    let keyValueStore: KeyValueStore

    init(keyValueStore: KeyValueStore, fallbackLanguage: LocalizationLanguage = .tr) {
        self.keyValueStore = keyValueStore
        self.fallback = fallbackLanguage
    }

    func set(to newLanguage: LocalizationLanguage) {
        keyValueStore.set(newLanguage.rawValue, forKey: Keys.selectedLanguage.rawValue)
    }

    func applyCurrent() {
        Bundle.setLanguage(currentLanguage.rawValue.lowercased())
    }

    var currentLanguage: LocalizationLanguage {
        if let persistedLang = keyValueStore.string(forKey: Keys.selectedLanguage.rawValue) {
            return languageOrFail(for: persistedLang)
        }
        if let systemLanguages = keyValueStore.stringArray(forKey: Keys.systemLanguages.rawValue),
           let preferredLang = systemLanguages.first {
            return languageOrFail(for: preferredLang)
        }

        return fallback
    }
    
    private func languageOrFail(for rawValue: LocalizationLanguage.RawValue) -> LocalizationLanguage {
        guard let language = LocalizationLanguage(rawValue: rawValue) else {
            // fatalError("Unsupported language. This is a development bug")
            return LocalizationLanguage.en
        }
        return language
    }
    
}

// MARK: Keys
extension LanguageService {
    enum Keys: String {
        case selectedLanguage
        case systemLanguages = "AppleLanguages"
    }
}

// MARK: Localization configure bundle
extension Bundle {
    class func setLanguage(_ language: String) {
        var onceToken: Int = 0

        if onceToken == 0 {
            object_setClass(Bundle.main, PrivateBundle.self)
        }
        onceToken = 1
        // swiftlint:disable line_length
        objc_setAssociatedObject(Bundle.main, &associatedLanguageBundle, (language != nil) ? Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj") ?? "") : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
private var associatedLanguageBundle: Character = "0"

class PrivateBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let bundle: Bundle? = objc_getAssociatedObject(self, &associatedLanguageBundle) as? Bundle
        return (bundle != nil) ? (bundle!.localizedString(forKey: key, value: value, table: tableName)) : (super.localizedString(forKey: key, value: value, table: tableName))
    }
}
