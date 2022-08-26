//
//  ViewController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/28/22.
//

import UIKit
import SnapKit

class LandingViewController: UIViewController {
    var campaigns: Campaigns!
    var onLoginPressed: (() -> Void)?
    var onLanguagePressed: (() -> Void)?
    var accountHolder: AccountHolder?
    
    convenience init(accountHolder: AccountHolder) {
        self.init(nibName: nil, bundle: nil)
        self.accountHolder = accountHolder
    }
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "th")
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var logo: UIImageView = {
        let image = UIImage(named: "logo2")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var userSwitch: UserAvatar = {
        let userView = UserAvatar(cornerRadius: view.frame.width * 0.1, showsMiniIcon: true, frame: .zero)
        userView.translatesAutoresizingMaskIntoConstraints = false
        return userView
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login".uppercased(), for: .normal)
        loginButton.setTitleColor(.darkGray, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        loginButton.backgroundColor = .white
        loginButton.contentEdgeInsets =  UIEdgeInsets(top: 12, left: 36, bottom: 12, right: 36)
        loginButton.layer.cornerRadius = 20
        loginButton.titleLabel?.lineBreakMode = .byWordWrapping
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        return loginButton
    }()
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let overlayLayer = CALayer()
        overlayLayer.frame = backgroundImage.bounds
        overlayLayer.backgroundColor = UIColor.red.withAlphaComponent(0.7).cgColor
        backgroundImage.layer.addSublayer(overlayLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureLayout()
    }
    
    @objc func doSomething() {
        print("do something")
    }
    
    @objc private func login() {
        onLoginPressed?()
    }
    
    @objc func closeLogin() {
        print("close")
        dismiss(animated: true)
    }
    
    @objc private func presentLanguageSelectionSheet() {
        onLanguagePressed?()
    }
}


// MARK: Autolayout
extension LandingViewController {
    
    private func configureNavigationBar() {
        let leftNavButton = UIBarButtonItem(title: "EN", style: .done, target: self, action: #selector(presentLanguageSelectionSheet))
        leftNavButton.tintColor = .white
        navigationItem.leftBarButtonItem = leftNavButton
        
        let rightNavButton = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .done, target: self, action: nil)
        rightNavButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightNavButton
    }
    

    
    private func configureLayout() {
        configureNavigationBar()
        view.addSubview(backgroundImage)
        view.addSubview(logo)
        view.addSubview(userSwitch)
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        logo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(125)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        NSLayoutConstraint.activate([
            logo.widthAnchor.constraint(equalTo: logo.heightAnchor, multiplier: 16/9)
        ])
        print("frame \(view.frame)")
        
        userSwitch.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom)
            make.centerX.equalTo(logo.snp.centerX)
            make.width.equalTo(view.frame.width * 0.2)
            make.height.equalTo(view.frame.width * 0.2)
        }
     
        let welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "Welcome to Ziraat Mobile"
        welcomeLabel.textColor = .white
        welcomeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        view.addSubview(welcomeLabel)
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(userSwitch.snp.bottom).offset(10)
            make.centerX.equalTo(userSwitch.snp.centerX)
        }
        
        let userTypeLabel = UILabel()
        userTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        userTypeLabel.text = "personal".uppercased()
        userTypeLabel.textColor = .white
        userTypeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        view.addSubview(userTypeLabel)
        
        userTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(5)
            make.centerX.equalTo(welcomeLabel.snp.centerX)
        }
        
        
        let userNameSurnameLabel = UILabel()
        userNameSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameSurnameLabel.text = accountHolder?.fullName ?? ""
        userNameSurnameLabel.textColor = .white
        userNameSurnameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        view.addSubview(userNameSurnameLabel)
        
        userNameSurnameLabel.snp.makeConstraints { make in
            make.top.equalTo(userTypeLabel.snp.bottom).offset(8)
            make.centerX.equalTo(userTypeLabel.snp.centerX)
        }
        
        
        
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(userNameSurnameLabel.snp.bottom).offset(25)
            make.centerX.equalTo(userNameSurnameLabel.snp.centerX)
        }
        
        let optionsBackground = UIView()
        optionsBackground.backgroundColor = .white
        view.addSubview(optionsBackground)
        optionsBackground.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(100)
        }
         
        
        let actionsBar = LandingBottomActionBar()
        view.addSubview(actionsBar)
        actionsBar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        campaigns = Campaigns()
        self.add(campaigns, frame: .zero)
        campaigns.view.translatesAutoresizingMaskIntoConstraints = false
        
        campaigns.view.snp.makeConstraints { make in
            make.bottom.equalTo(actionsBar.snp.top).offset(-10)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(150)
        }
    }
}








