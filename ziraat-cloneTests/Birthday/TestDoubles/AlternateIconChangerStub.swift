//
//  AlternateIconChangerStub.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/11/22.
//

import Foundation
@testable import ziraat_clone

class AlternateIconChangerStub: AlternateIconChanger {
    let error: Error?

    init(error: Error?) {
        self.error = error
    }
    
    func setAlternateIconName(_ alternateIconName: String?, completionHandler: ((Error?) -> Void)?) {
        completionHandler?(error)
    }
}
