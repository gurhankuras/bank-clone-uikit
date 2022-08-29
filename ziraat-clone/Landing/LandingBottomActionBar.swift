//
//  LandingActionsStackView.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/25/22.
//

import Foundation
import UIKit

class LandingBottomActionBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let qrOption = makeOptionContainer(with: "qrcode", title: L10n.qr_operation.localized)
        let transfersOption = makeOptionContainer(with: "arrow.left.arrow.right", title: L10n.easy_transfer.localized)
        let financialOption = makeOptionContainer(with: "chart.bar.xaxis", title: L10n.financial_data.localized)
        let approvalOption = makeOptionContainer(with: "checkmark.circle.fill", title: L10n.ziraat_approval.localized)
        let otherTransactionsOption = makeOptionContainer(with: "square.grid.2x2.fill", title: L10n.other_transactions.localized)

        let optionsStack = UIStackView(arrangedSubviews: [qrOption, transfersOption, financialOption, approvalOption, otherTransactionsOption])
        optionsStack.distribution = .fillEqually

        addSubview(optionsStack)
        optionsStack.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
            make.bottom.top.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeOptionContainer(with image: String, title: String) -> UIView {
        let optionImage = UIImage(systemName: image)
        let optionImageView = UIImageView(image: optionImage)
        optionImageView.translatesAutoresizingMaskIntoConstraints = false
        optionImageView.tintColor = .red
        
        let optionContainer = UIView()
        optionContainer.translatesAutoresizingMaskIntoConstraints = false
        optionContainer.backgroundColor = UIColor.quaternarySystemFill
        optionContainer.layer.cornerRadius = 15
        
        optionContainer.addSubview(optionImageView)
        optionImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(optionContainer)
            make.width.equalTo(optionContainer.snp.width).multipliedBy(0.6)
            make.height.equalTo(optionContainer.snp.width).multipliedBy(0.6)
        }
        
        
        let optionWrapper = UIView()
        optionWrapper.translatesAutoresizingMaskIntoConstraints = false
        optionWrapper.addSubview(optionContainer)
        
        optionContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(50)
        }
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        optionWrapper.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(optionContainer.snp.bottom).offset(5)
            make.width.equalTo(optionWrapper).multipliedBy(0.9)
            make.centerX.equalTo(optionWrapper)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doSomething))
        optionWrapper.addGestureRecognizer(tapGesture)
        return optionWrapper

    }
    
    @objc func doSomething() {
        print("do something")
    }
    
}
