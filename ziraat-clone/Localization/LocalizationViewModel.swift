//
//  LocalizationViewModel.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/26/22.
//

import Foundation

class LocalizationViewModel {
    var didSelectLanguage: ((LocalizationLanguage) -> Void)?
    var supportedLanguages: [LocalizationLanguage] = [.tr, .en]
    var selectedLanguage: LocalizationLanguage = .tr {
        didSet {
            languageService.set(to: selectedLanguage)
            languageService.applyCurrent()
            didSelectLanguage?(selectedLanguage)
        }
    }
    let languageService: LocalizationService

    init(languageService: LocalizationService) {
        self.languageService = languageService
        selectedLanguage = languageService.currentLanguage
    }
}
