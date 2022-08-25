//
//  AccountHead.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/30/22.
//
import Foundation
import UIKit

class AccountHead: UIView {
    var allMyAccountsButton: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let accountImage = UIImage(named: "account")
        let accountImageView = UIImageView(image: accountImage)
        
        addSubview(accountImageView)
        
        accountImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(layoutMarginsGuide)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        let chevronBackward = UIImage(systemName: "chevron.backward")
        // let backButtonImageView = UIImageView(image: chevronBackward)
       
        
        let backButton = UIButton()
        backButton.setImage(chevronBackward, for: .normal)
        backButton.imageView?.tintColor = .white
        backButton.contentVerticalAlignment = .fill
        backButton.contentHorizontalAlignment = .fill
        backButton.addTarget(self, action: #selector(backTo), for: .touchUpInside)
    
        addSubview(backButton)
    
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(accountImageView)
            make.leading.equalTo(layoutMarginsGuide)
            make.height.equalTo(30)
            make.width.equalTo(20)
        }
        
        let chevronForward = UIImage(systemName: "chevron.forward")

        let nextButton = UIButton()
        nextButton.setImage(chevronForward, for: .normal)
        nextButton.imageView?.tintColor = .white
        nextButton.contentVerticalAlignment = .fill
        nextButton.contentHorizontalAlignment = .fill
        nextButton.addTarget(self, action: #selector(backTo), for: .touchUpInside)
    
        addSubview(nextButton)
    
        nextButton.snp.makeConstraints { make in
            make.trailing.equalTo(layoutMarginsGuide)
            make.bottom.equalTo(accountImageView)
            make.height.equalTo(30)
            make.width.equalTo(20)
        }
        
        
        let accountBranchNameLabel = UILabel()
        accountBranchNameLabel.textColor = .white
        accountBranchNameLabel.textAlignment = .center
        accountBranchNameLabel.text = "Örnek Mahallesi/İstanbul Şubesi".uppercased(with: Locale(identifier: "tr"))
        accountBranchNameLabel.numberOfLines = 2
        accountBranchNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        addSubview(accountBranchNameLabel)
        
        accountBranchNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(accountImageView.snp.bottom).offset(20)
        }
        
        let accountNumberLabel = UILabel()
        accountNumberLabel.textColor = .secondaryLabel
        accountNumberLabel.textAlignment = .center
        accountNumberLabel.text = "2133-85645327-6484"
        accountNumberLabel.numberOfLines = 1
        accountNumberLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        addSubview(accountNumberLabel)
        
        accountNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(accountBranchNameLabel.snp.bottom).offset(5)
        }
        
        allMyAccountsButton = UIView()
        allMyAccountsButton.backgroundColor = .white
        
        let allMyAccountsLabel = UILabel()
        allMyAccountsLabel.text = "All My Accounts"
        allMyAccountsLabel.textColor = .black
        allMyAccountsLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        allMyAccountsLabel.numberOfLines = 1
        
        allMyAccountsButton.addSubview(allMyAccountsLabel)
        
        allMyAccountsLabel.snp.makeConstraints { make in
            let horizontalPadding = 15
            let verticalPadding = 8
            
            make.leading.equalTo(allMyAccountsButton).offset(horizontalPadding)
            make.centerY.equalTo(allMyAccountsButton)
            make.top.equalToSuperview().offset(verticalPadding)
            make.bottom.equalToSuperview().offset(-verticalPadding)

        }
        
       
        let allMyAccountsChevron = UIImage(systemName: "chevron.forward")
        let allMyAccountsChevronImageView = UIImageView(image: allMyAccountsChevron)
        
       
        allMyAccountsChevronImageView.tintColor = .black
        allMyAccountsChevronImageView.contentMode = .scaleAspectFit
        
        allMyAccountsButton.addSubview(allMyAccountsChevronImageView)
        
        allMyAccountsLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        allMyAccountsChevronImageView.setContentCompressionResistancePriority(UILayoutPriority(250), for: .vertical)
        
        
        allMyAccountsChevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(allMyAccountsButton)
            make.height.equalTo(allMyAccountsLabel)
            make.leading.equalTo(allMyAccountsLabel.snp.trailing).offset(8)
            make.trailing.equalTo(allMyAccountsButton).offset(-15)
        }
        
        addSubview(allMyAccountsButton)
        
        allMyAccountsButton.snp.makeConstraints { make in
            make.top.equalTo(accountNumberLabel.snp.bottom).offset(12)
            make.centerX.equalTo(self)
            make.bottom.equalTo(layoutMarginsGuide)
            //make.width.equalTo(contentView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        allMyAccountsButton.layer.cornerRadius = allMyAccountsButton.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func backTo() {
        print("backto")
    }
}
