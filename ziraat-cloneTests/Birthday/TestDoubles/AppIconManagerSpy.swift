//
//  AppIconManagerSpy.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/11/22.
//

import Foundation
@testable import ziraat_clone

class AppIconManagerSpy: AppIconManaging {
    private let _currentIcon: AppIcon?
    private let error: Error?
    private(set) var icons = [AppIcon?]()
    
    init(currentIcon: AppIcon?, error: Error?) {
        self._currentIcon = currentIcon
        self.error = error
    }
    
    var currentIcon: AppIcon? { _currentIcon }
    func `switch`(to icon: AppIcon, completion: @escaping (Error?) -> Void) {
        icons.append(icon)
        completion(error)
    }
}
