//
//  CustomAlertController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/27/22.
//

import Foundation
import UIKit
import Lottie



class CustomAlertController: UIViewController {
    private var actionButtons: [UIButton] = []
    private var message: String?
    private var type: AlertType?

    enum AlertType: String {
        case warning
    }
    
    lazy var animationView: AnimationView = {
        let v = AnimationView(name: (self.type ?? AlertType.warning).rawValue)
        v.contentMode = .scaleAspectFit
        v.loopMode = .playOnce
        return v
    }()
    
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = self.message ?? ""
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageLabel.numberOfLines = 0

    }
    
    convenience init(message: String, type: AlertType) {
        self.init(nibName: nil, bundle: nil)
        self.message = message
        self.type = type
    }
    
    deinit { log_deinit(Self.self) }
    
    func addAction(_ action: CustomAlertActionItem) {
        actionButtons.append(button(with: action))
    }
    
    private func button(with action: CustomAlertActionItem) -> CustomAlertButton {
        let button = CustomAlertButton(action: action)
        button.addTarget(self, action: #selector(actionButtonPressed(_:)), for: .touchUpInside)
        return button
    }
    
    override func loadView() {
        super.loadView()
        let padding = 15.0
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layoutMargins = UIEdgeInsets.init(top: 0, left: padding, bottom: padding, right: padding)
    }
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: actionButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMargins)
            make.centerX.equalTo(view)
            make.width.height.equalTo(100)
        }
        
        view.addSubview(messageLabel)
        messageLabel.doesNotWantToShrink(.defaultHigh, for: .vertical)
        messageLabel.doesNotWantToGrow(.defaultLow, for: .vertical)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).inset(5)
            make.leading.trailing.equalTo(view.layoutMargins)
        }
        
        view.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.layoutMargins)
            make.trailing.equalTo(view.layoutMargins)
            make.top.equalTo(messageLabel.snp.bottom).offset(8.0).priority(.low)
            make.bottom.equalTo(view.layoutMargins)
        }
        
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func actionButtonPressed(_ sender: UIButton) {
        guard let actionButton = sender as? CustomAlertButton else { return }
        presentingViewController?.dismiss(animated: true) {
            if let action = actionButton.action {
                action.handler(action)
            }
        }
    }
}
// MARK: UIViewControllerTransitioningDelegate
extension CustomAlertController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomAlertPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScalingFadingAnimatedTransition(duration: 0.6)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScalingFadingAnimatedTransition(duration: 0.3, for: .dismiss)
    }
}

// MARK: CustomAlertActionItem & AlertButtonStyle
extension CustomAlertController {
    struct CustomAlertActionItem {
        let title: String
        let style: AlertButtonStyle
        let handler: (CustomAlertActionItem) -> Void
    }
    
    enum AlertButtonStyle {
        case filled
        case outlined
    }
}

// MARK: CustomAlertButton
extension CustomAlertController {
    class CustomAlertButton: UIButton {
        var action: CustomAlertActionItem!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        convenience init(action: CustomAlertActionItem) {
            self.init(frame: .zero)
            self.action = action
            configure()
        }
        
        private func configure() {
            let style = action.style
            let title = action.title
            setTitleColor(style == .filled ? .white : .black, for: .normal)
            setTitleColor(style == .filled ? .white.withAlphaComponent(0.5) : .black.withAlphaComponent(0.5), for: .highlighted)
            titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            backgroundColor = style == .filled ? .red : .clear
            layer.borderColor = style == .filled ? UIColor.red.cgColor : UIColor.black.cgColor
            layer.borderWidth = 1
            layer.cornerRadius = 20
            titleLabel?.lineBreakMode = .byWordWrapping
            
            setTitle(title.capitalized, for: .normal)
            contentEdgeInsets =  UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


extension CustomAlertController {
    func updatePresentationLayout(animated: Bool = false) {
        presentationController?.containerView?.setNeedsLayout()
        if animated {
          UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            self.presentationController?.containerView?.layoutIfNeeded()
          }, completion: nil)
        } else {
          presentationController?.containerView?.layoutIfNeeded()
        }
      }
}
