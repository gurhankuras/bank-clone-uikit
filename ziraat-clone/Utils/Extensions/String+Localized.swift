//
//  String+Localized.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/26/22.
//

import Foundation

extension String {
    func localized() -> Self {
        NSLocalizedString(self, tableName: nil, bundle: .main, value: self, comment: self)
    }
}

enum L10n: String {
    case landing_login_button_title
    case qr_operation
    case login_button_title
    case personal_text
    case welcome_message
    case easy_transfer
    case financial_data
    case ziraat_approval
    case other_transactions
    case change_user
    case password_placeholder
    case close_button_text
    case yes
    case no
    case app_exit_warning_message

    var localized: String {
        NSLocalizedString(self.rawValue, tableName: nil, bundle: .main, value: self.rawValue, comment: self.rawValue)
    }

}
