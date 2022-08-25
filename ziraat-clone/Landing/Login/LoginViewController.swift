//
//  LoginViewController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/28/22.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    var onClose: (() -> Void)?
    var onLogin: (() -> Void)?
    var closeButton: LoginSheetCloseButton!
    var viewModel: LoginViewModel!
    
    
    /*
    convenience init(viewModel: LoginViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
     */
    
    lazy var loginTransitionDelegate: LoginSheetTransitionDelegate = {
        let loginTransitionDelegate = LoginSheetTransitionDelegate()
        loginTransitionDelegate.onClose = { [weak self] in
            self?.dismiss(animated: true)
        }
        return loginTransitionDelegate
    }()
    
    lazy var loginInfo: LoginWelcomeMessageView = {
        let info = LoginWelcomeMessageView(userType: .personal, formalName: viewModel.accountHolder?.fullName ?? "")
        info.translatesAutoresizingMaskIntoConstraints = false
        return info
    }()
    
    lazy var loginButton: UIButton = {
        let button = LoginButton()
        button.setBackgroundColor(.red, for: .enabled)
        button.setBackgroundColor(.red.withAlphaComponent(0.5), for: .disabled)
        button.setTitle("Login".uppercased(), for: .normal)
        button.contentEdgeInsets =  UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        button.isEnabled = false
        return button
    }()
    
    deinit {
        print("LoginViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        transitioningDelegate = loginTransitionDelegate
        configureLayout()
        viewModel.onSubmitted = { [weak self] result in
            switch result {
            case .success:
                self?.onLogin?()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        
        viewModel.onAutoLoginAttempt = { [weak self] result in
            switch result {
            case .success:
                self?.onLogin?()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        
        loginButton.backgroundColor = viewModel.password.isValid ? .red : .red.withAlphaComponent(0.5)
        
        
        
        
        viewModel.onPasswordChange = { [weak self] password in
            guard let self = self else { return }
            self.loginButton.isEnabled = self.viewModel.password.isValid
        }
    }
    
    @objc func login() {
        viewModel.attempLogin()
    }
    
    @objc func changeUser() {
        print("change user")
    }
    
    @objc func closeS() {
        print("closeS")
    }
}


extension LoginViewController {
    private func configureLayout() {
        let userAvatar = UserAvatar(cornerRadius: 45, showsMiniIcon: false, frame: .zero)
        userAvatar.tag = 99
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userAvatar)
        userAvatar.snp.makeConstraints { make in
            let size = 90
            make.top.equalTo(view).offset(-size / 2)
            make.centerX.equalTo(view)
            make.height.equalTo(size)
            make.width.equalTo(size)
        }

        view.addSubview(loginInfo)
        loginInfo.snp.makeConstraints { make in
            make.top.equalTo(userAvatar.snp.bottom)
            make.centerX.equalTo(userAvatar)
        }
        
        let changeUserButton = UIButton()
        let buttonText =  "Change User"
        let buttonTitle = NSMutableAttributedString(string: buttonText)
        let buttonTextRange = NSRange(location: 0, length: buttonTitle.length)
        buttonTitle.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: buttonTextRange)
        buttonTitle.addAttribute(.underlineColor, value: UIColor.darkGray, range: buttonTextRange)
        changeUserButton.isUserInteractionEnabled = false
        buttonTitle.addAttribute(.foregroundColor, value: UIColor.darkGray, range: buttonTextRange)
        buttonTitle.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .semibold), range: buttonTextRange)
        changeUserButton.setAttributedTitle(buttonTitle, for: .normal)
        changeUserButton.isUserInteractionEnabled = true
        changeUserButton.addTarget(self, action: #selector(changeUser), for: .touchUpInside)
        changeUserButton.setTitleColor(.red, for: .normal)
        
        view.addSubview(changeUserButton)
    
        changeUserButton.snp.makeConstraints { make in
            make.top.equalTo(loginInfo.snp.bottom)
            make.centerX.equalTo(loginInfo)
        }
        
        let passwordField = UITextField()
        passwordField.delegate = self
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = .clear
        passwordField.isSecureTextEntry = true
        passwordField.textColor = .black
        passwordField.pasteDelegate = self
        passwordField.keyboardType = .numberPad
        passwordField.leftViewMode = .always
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        passwordField.leftView = paddingView
        let placeholder = NSMutableAttributedString(string: "Password")
        let range = NSRange(location: 0, length: placeholder.length)
        placeholder.addAttribute(.foregroundColor, value: UIColor.darkGray, range: range)
        placeholder.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: range)

        passwordField.attributedPlaceholder = placeholder

        passwordField.layer.borderWidth = 1
        passwordField.layer.cornerRadius = 18
        passwordField.layer.borderColor = UIColor.darkGray.cgColor
        
        view.addSubview(passwordField)
        let horizontalPadding = 20
        //passwordField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)

        passwordField.snp.makeConstraints { make in
            make.top.equalTo(changeUserButton.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(horizontalPadding)
            make.trailing.equalTo(view).offset(-horizontalPadding)
            
            make.height.equalTo(50)
        }
        
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(12)
            make.centerX.equalTo(passwordField.snp.centerX)
            make.leading.equalTo(view).offset(horizontalPadding)
            make.trailing.equalTo(view).offset(-horizontalPadding)
        }
         
        closeButton = LoginSheetCloseButton()
        closeButton.isUserInteractionEnabled = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.onClose = onClose
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view)
        }
    }
    
    @objc func passwordDidChange(_ sender: UITextField) {
        print("password changed")
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("didendediting")
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newPassword = NSString(string: textField.text!).replacingCharacters(in: range, with: string) as String
        let valid = viewModel.shouldPermitEditing(for: newPassword)
        if valid {
            viewModel.password = LoginPassword(newPassword)
            print("password set: \(viewModel.password)")
        }
         return valid
    }
}

extension LoginViewController: UITextPasteDelegate {
    
}
