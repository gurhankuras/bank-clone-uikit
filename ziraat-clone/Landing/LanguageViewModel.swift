//
//  LanguageViewModel.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/26/22.
//

import Foundation

enum Language: String {
    case tr = "TR", en = "EN"
}


class LanguageViewModel {
    var didSelectLanguage: ((Language) -> Void)?
    var supportedLanguages: [Language] = [.tr, .en]
    var selectedLanguage: Language = .tr {
        didSet {
            didSelectLanguage?(selectedLanguage)
        }
    }
}
