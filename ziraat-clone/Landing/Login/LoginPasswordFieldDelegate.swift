//
//  LoginPasswordFieldDelegate.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/25/22.
//

import Foundation
import UIKit

class LoginPasswordFieldDelegate: NSObject, UITextFieldDelegate {
    var viewModel: LoginViewModel!
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("didendediting")
    }

    convenience init(viewModel: LoginViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newPassword = NSString(string: text).replacingCharacters(in: range, with: string) as String
        let valid = viewModel.shouldPermitEditing(for: newPassword)
        if valid {
            viewModel.password = LoginPassword(newPassword)
            print("password set: \(viewModel.password)")
        }
         return valid
    }
}
