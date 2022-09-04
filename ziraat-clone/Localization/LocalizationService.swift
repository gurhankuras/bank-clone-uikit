//
//  LocalizationService.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation

protocol LocalizationService {
    var currentLanguage: LocalizationLanguage { get }
    func applyCurrent()
    func `set`(to newLanguage: LocalizationLanguage)
}
