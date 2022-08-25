//
//  LoginButton.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/23/22.
//

import Foundation
import UIKit

class LoginButton: UIButton {
    private(set) var disabledBackgroundColor: UIColor?
    private(set) var enabledBackgroundColor: UIColor?
    
    enum State {
        case enabled, disabled
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = (isEnabled ? enabledBackgroundColor : disabledBackgroundColor) ?? backgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func setBackgroundColor(_ color: UIColor, for state: State) {
        switch state {
        case .enabled:
            enabledBackgroundColor = color
        case .disabled:
            disabledBackgroundColor = color
        }
    }
    
    private func configure() {
        setTitleColor(.white, for: .normal)
        setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        backgroundColor = .red
        layer.cornerRadius = 20
        titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
