//
//  AppLanguage.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/27/22.
//

import Foundation

protocol AppLanguageChanging {
    func `set`(to language: Language)
}

protocol AppLanguageApplying {
    func applyCurrent()
}

protocol AppLanguageProviding {
    var currentLanguage: Language { get }
}

typealias AppLanguageUser = AppLanguageChanging & AppLanguageApplying & AppLanguageProviding



class AppLanguageService: AppLanguageUser {
    private let key = "selectedLanguage"
    private let defaultLanguage: Language = .tr
    
    func set(to language: Language) {
        UserDefaults.standard.set(language.rawValue, forKey: key)
    }
    
    func applyCurrent() {
        Bundle.setLanguage(currentLanguage.rawValue.lowercased())
    }
    
    var currentLanguage: Language {
        if let persistedLanguage = UserDefaults.standard.string(forKey: key) {
            return Language(rawValue: persistedLanguage) ?? defaultLanguage
        }
        if let preferredLanguages = UserDefaults.standard.stringArray(forKey: "AppleLanguages"),
           let systemLanguage = preferredLanguages.first {
            return Language(rawValue: systemLanguage) ?? defaultLanguage
        }

        return defaultLanguage
    }
}

//MARK: Localization configure bundle
extension Bundle {
    class func setLanguage(_ language: String) {
        var onceToken: Int = 0
        
        if (onceToken == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            object_setClass(Bundle.main, PrivateBundle.self)
        }
        onceToken = 1
        objc_setAssociatedObject(Bundle.main, &associatedLanguageBundle, (language != nil) ? Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj") ?? "") : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
private var associatedLanguageBundle:Character = "0"

class PrivateBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let bundle: Bundle? = objc_getAssociatedObject(self, &associatedLanguageBundle) as? Bundle
        return (bundle != nil) ? (bundle!.localizedString(forKey: key, value: value, table: tableName)) : (super.localizedString(forKey: key, value: value, table: tableName))
    }
}
