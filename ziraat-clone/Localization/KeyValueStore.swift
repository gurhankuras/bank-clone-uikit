//
//  KeyValueStore.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation

protocol KeyValueStore {
    func set(_ value: Any?, forKey defaultName: String)
    func string(forKey defaultName: String) -> String?
    func stringArray(forKey defaultName: String) -> [String]?
}

extension UserDefaults: KeyValueStore {
    
}
