//
//  LandingActionsStackView.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/25/22.
//

import Foundation
import UIKit

class LandingBottomActionBar: UIView {
    let actions: [ActionItem] = [
        .init(systemImage: "qrcode", title: L10n.qr_operation.localized, handle: { action in print(action.title) }),
        .init(systemImage: "arrow.left.arrow.right",
              title: L10n.easy_transfer.localized,
              handle: { action in print(action.title) }),
        .init(systemImage: "chart.bar.xaxis", title: L10n.financial_data.localized, handle: {_ in}),
        .init(systemImage: "checkmark.circle.fill", title: L10n.ziraat_approval.localized, handle: {_ in}),
        .init(systemImage: "square.grid.2x2.fill", title: L10n.other_transactions.localized, handle: {_ in})
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        let actionsStack = UIStackView(arrangedSubviews: actions.map({ ActionButton(action: $0) }))
        actionsStack.isLayoutMarginsRelativeArrangement = true
        actionsStack.layoutMargins = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
        actionsStack.distribution = .fillEqually
        actionsStack.alignment = .leading
        actionsStack.spacing = 8

        addSubview(actionsStack)
        actionsStack.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
            make.bottom.top.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LandingBottomActionBar {
    struct ActionItem {
        let systemImage: String
        let title: String
        let handle: (ActionItem) -> Void
    }
}

extension LandingBottomActionBar {
    class ActionButton: UIButton {
        var action: ActionItem!

        override init(frame: CGRect) {
            super.init(frame: frame)
            translatesAutoresizingMaskIntoConstraints = false
        }

        lazy var label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = action.title
            label.textColor = .darkGray
            label.font = .systemFont(ofSize: 11, weight: .semibold)
            label.textAlignment = .center
            label.numberOfLines = 2
            return label
        }()

        lazy var actionImageView: UIImageView = {
            let image = UIImage(systemName: action.systemImage)
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.tintColor = .red
            return imageView
        }()
        
        lazy var imageContainer: UIView = {
            let actionContainer = UIView()
            actionContainer.translatesAutoresizingMaskIntoConstraints = false
            actionContainer.backgroundColor = UIColor.quaternarySystemFill
            actionContainer.layer.cornerRadius = 15
            return actionContainer
        }()

        convenience init(action: ActionItem) {
            self.init(frame: .zero)
            self.action = action
            
            /*
            label.backgroundColor = .red.withAlphaComponent(0.3)
            layer.borderColor = UIColor.green.cgColor
            layer.borderWidth = 1
            */
            imageContainer.addSubview(actionImageView)
            imageContainer.snp.makeConstraints { make in
                make.width.height.equalTo(50)
            }

            actionImageView.snp.makeConstraints { make in
                make.centerX.centerY.equalTo(imageContainer)
                make.width.equalTo(imageContainer.snp.width).multipliedBy(0.6)
                make.height.equalTo(imageContainer.snp.width).multipliedBy(0.6)
            }

            let containerStackView = UIStackView(arrangedSubviews: [imageContainer, label])
            
            containerStackView.axis = .vertical
            containerStackView.alignment = .center
            containerStackView.distribution = .fill
            containerStackView.spacing = 6

            addSubview(containerStackView)
            containerStackView.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalToSuperview()
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAction))
            addGestureRecognizer(tapGesture)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private func handleAction() {
            self.action.handle(action)
            print("handle action")
        }
    }
}
