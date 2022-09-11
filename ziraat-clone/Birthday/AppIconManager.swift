//
//  AppIconSwitcher.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/9/22.
//

import Foundation
import UIKit

protocol AlternateIconChanger {
    func setAlternateIconName(_ alternateIconName: String?, completionHandler: ((Error?) -> Void)?)
}

extension UIApplication: AlternateIconChanger {}

class AppIconManager: AppIconManaging {
    static let iconKey = "active_app_icon"
    
    let changer: AlternateIconChanger
    let keyValueStore: KeyValueStore

    init(changer: AlternateIconChanger, keyValueStore: KeyValueStore) {
        self.keyValueStore = keyValueStore
        self.changer = changer
    }
    
    var currentIcon: AppIcon? {
        guard let currentIconString = keyValueStore.string(forKey: Self.iconKey) else {
            return .normal
        }
        guard let icon = AppIcon(rawValue: currentIconString) else {
            fatalError("Invalid app icon. This is likely a developer mistake.")
        }
        return icon
    }
    
    func `switch`(to icon: AppIcon, completion: @escaping (Error?) -> Void) {
        let toIcon = icon == .normal ? nil : icon.rawValue
        changer.setAlternateIconName(toIcon, completionHandler: {[weak self] error in
            defer { completion(error) }
            guard error == nil else { print(error!.localizedDescription); return }
            self?.keyValueStore.set(icon.rawValue, forKey: Self.iconKey)
        })
    }
}
