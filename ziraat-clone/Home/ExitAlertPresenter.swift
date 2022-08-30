//
//  ExitAlertPresenter.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/28/22.
//

import Foundation
import UIKit

enum ExitAlertPresenter {
    static func present(on navigationController: UINavigationController?) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        let message = L10n.app_exit_warning_message.localized
        let alert = CustomAlertController(message: message, type: .warning)

        alert.addAction(.init(title: L10n.yes.localized, style: .filled, handler: { _ in
            navigationController?.popViewController(animated: true)
        }))
        alert.addAction(.init(title: L10n.no.localized, style: .outlined, handler: { action in
            print(action.title)
        }))

        navigationController?.present(alert, animated: true)
    }
}
