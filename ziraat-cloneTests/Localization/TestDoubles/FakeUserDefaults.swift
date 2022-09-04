//
//  FakeUserDefaults.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation
@testable import ziraat_clone

class FakeUserDefaults: KeyValueStore {
    var strings: [String: String] = [:]
    var stringArrays: [String: [String]] = [:]
    
    func set(_ value: Any?, forKey defaultName: String) {
        guard let value = value as? String else {
            return
        }
        strings[defaultName] = value
    }
    
    func string(forKey defaultName: String) -> String? {
        return strings[defaultName]
    }
    
    func stringArray(forKey defaultName: String) -> [String]? {
        return stringArrays[defaultName]
    }
}
