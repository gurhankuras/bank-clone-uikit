//
//  LoginWelcomeMessageView.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/29/22.
//

import Foundation
import UIKit

enum UserType: String {
    case personal
    case business
}

class LoginWelcomeMessageView: UIView {
    var verticalStack: UIStackView!
    var userType: UserType?
    var formalName: String?
    
    convenience init(userType: UserType, formalName: String) {
        self.init(frame: .zero)
        customize(userType: userType, formalName: formalName)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize(userType: .personal, formalName: " ")
    }
    
    private func customize(userType: UserType, formalName: String) {
        let textColor = UIColor.darkGray
        
        let welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "Welcome to Ziraat Mobile"
        welcomeLabel.textColor = textColor
        welcomeLabel.font = .systemFont(ofSize: 14, weight: .regular)
  
        let userNameSurnameLabel = UILabel()
        userNameSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
       
        userNameSurnameLabel.textColor = textColor
        userNameSurnameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        let string = NSMutableAttributedString(string: formalName)
        string.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: NSRange(location: 0, length: string.length - 1))
        userNameSurnameLabel.attributedText = string
        
        let userTypeLabel = UILabel()
        userTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        userTypeLabel.text = userType.rawValue.uppercased()
        userTypeLabel.textColor = textColor
        userTypeLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        
        verticalStack = UIStackView(arrangedSubviews: [welcomeLabel, userNameSurnameLabel, userTypeLabel])
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = 2

        addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
