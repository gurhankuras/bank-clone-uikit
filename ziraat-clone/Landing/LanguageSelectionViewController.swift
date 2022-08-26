//
//  LanguageSelectionViewController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/25/22.
//

import Foundation
import UIKit


class LanguageButton: UIButton {
    var language: Language!
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .red
            } else {
                backgroundColor = .white
            }
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(language: Language) {
        self.init(frame: .zero)
        self.language = language
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class LanguageSelectionViewController: UIViewController {
    var didSelectLanguage: ((Language) -> Void)?
    var selectedLanguage: Language = .tr {
        didSet {
            updateButtons()
        }
    }
    
    private func updateButtons() {
        languageButtons.forEach { button in
            button.isSelected = button.language == selectedLanguage
        }
    }
    
    
    lazy var loginTransitionDelegate: LanguageSelectionTransitionDelegate = {
        let loginTransitionDelegate = LanguageSelectionTransitionDelegate()
        loginTransitionDelegate.onClose = { [weak self] in
            self?.dismiss(animated: true)
        }
        return loginTransitionDelegate
    }()
    
    private var languageButtons: [LanguageButton] = []
    
    private func languageButton(with language: Language) -> LanguageButton {
        let button = LanguageButton(language: language)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(language.rawValue, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote).bold()
        button.backgroundColor = .primary
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(dummySelector), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return button
    }
    
    lazy var selection: UIStackView = {
        let icon = UIImage(systemName: "globe")
        let iconImageView = UIImageView(image: icon)
        iconImageView.tintColor = .black
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Dil Seçimi:"
        titleLabel.textColor = .black
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = .preferredFont(forTextStyle: .footnote)
        let turkishButton = languageButton(with: .tr)
        let englishButton = languageButton(with: .en)
        languageButtons.append(contentsOf: [turkishButton, englishButton])
       
        
        
        
        
        
        let horizontalStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, turkishButton, englishButton])
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 6
        horizontalStackView.distribution = .fill
        

        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        
        
        return horizontalStackView
    }()
    
    @objc func dummySelector(_ sender: UIButton) {
        guard let languageButton = sender as? LanguageButton else { return }
        print("dummy \(languageButton.language?.rawValue)")
        selectedLanguage = languageButton.language
        didSelectLanguage?(selectedLanguage)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = loginTransitionDelegate

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(selection)
        let horizontalPadding = 16
        selection.snp.makeConstraints { make in
            make.top.equalTo(view).inset(horizontalPadding)
            make.leading.equalTo(view).inset(horizontalPadding)
        }
        
        let divider = UIView()
        divider.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(selection.snp.bottom).offset(8)
            make.height.equalTo(1)
            make.leading.equalTo(selection)
            make.trailing.equalTo(view).inset(horizontalPadding)
        }
        
        updateButtons()
        /*
        view.addSubview(languageButton)
        languageButton.snp.makeConstraints { make in
            make.leading.equalTo(selection.snp.trailing)
            make.top.equalTo(selection.snp.top)
        }
         */
    }
    
}

