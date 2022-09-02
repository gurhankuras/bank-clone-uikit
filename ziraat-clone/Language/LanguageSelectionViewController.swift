//
//  LanguageSelectionViewController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/25/22.
//

import Foundation
import UIKit

class LanguageSelectionViewController: UIViewController {
    var didSelectLanguage: ((Language) -> Void)?
    var viewModel: LanguageViewModel!
    private var languageButtons: [LanguageButton] = []

    lazy var loginTransitionDelegate: LanguageSelectionTransitionDelegate = {
        let loginTransitionDelegate = LanguageSelectionTransitionDelegate()
        loginTransitionDelegate.onClose = { [weak self] in
            self?.dismiss(animated: true)
        }
        return loginTransitionDelegate
    }()

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

        languageButtons.append(contentsOf: self.viewModel.supportedLanguages.map({ languageButton(with: $0) }))

        let horizontalStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel] + languageButtons)
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
        print("dummy \(String(describing: languageButton.language?.rawValue))")
        viewModel.selectedLanguage = languageButton.language
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = loginTransitionDelegate

    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        updateButtons(with: viewModel.selectedLanguage)

        viewModel.didSelectLanguage = { [weak self] newLanguage in
            self?.updateButtons(with: newLanguage)
            self?.didSelectLanguage?(newLanguage)
        }
    }

    private func configureLayout() {
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

        let closeButton = CloseButton()
        closeButton.axis = .horizontal
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.onClose = { [weak self] in
            self?.dismiss(animated: true)
        }

        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalTo(divider)
            make.top.equalTo(divider).offset(10)
            make.trailing.equalTo(divider)
        }
    }

    private func updateButtons(with language: Language) {
        languageButtons.forEach { button in
            button.isSelected = button.language == language
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
