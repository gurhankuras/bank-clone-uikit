//
//  AppLanguage.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/27/22.
//

import Foundation

protocol LanguageService {
    var currentLanguage: Language { get }
    func applyCurrent()
    func `set`(to newLanguage: Language)
}

class AppLanguageService: LanguageService {
    private let fallback: Language = .tr

    func set(to newLanguage: Language) {
        UserDefaults.standard.set(newLanguage.rawValue, forKey: Keys.selectedLanguage.rawValue)
    }

    func applyCurrent() {
        Bundle.setLanguage(currentLanguage.rawValue.lowercased())
    }

    var currentLanguage: Language {
        if let persistedLang = UserDefaults.standard.string(forKey: Keys.selectedLanguage.rawValue) {
            return Language(rawValue: persistedLang) ?? fallback
        }
        if let systemLanguages = UserDefaults.standard.stringArray(forKey: Keys.systemLanguages.rawValue),
           let preferredLang = systemLanguages.first {
            return Language(rawValue: preferredLang) ?? fallback
        }

        return fallback
    }
}

// MARK: Keys
extension AppLanguageService {
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
