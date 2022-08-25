//
//  AccountHolder.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/19/22.
//

import Foundation

struct AccountHolder {
    let tc: String
    let firstName: String
    let middleName: String?
    let surname: String
    
    
    
    var fullName: String {
        if let middleName = middleName {
            return "\(firstName) \(middleName) \(surname)"
        }
        return "\(firstName) \(surname)"
    }
}

extension AccountHolder {
    static var stub: AccountHolder {
        AccountHolder(tc: "21484486692", firstName: "Tevfik", middleName: "Gurhan", surname: "Kuraş")
    }
}
/*
extension AccountHolder {
    init(tc: String, fullName: String) {
        let nameComponents = fullName.components(separatedBy: .whitespaces)
        if nameComponents.count == 2 {
            self.firstName = nameComponents.first!
            self.surname = nameComponents.last!
        }
        else {
    }
}
*/
