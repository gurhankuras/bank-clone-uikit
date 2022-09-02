//
//  LanguageButton.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/26/22.
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
            layer.shadowColor = isSelected ?  UIColor.red.cgColor : UIColor.black.cgColor
            layer.shadowRadius = 1
            layer.shadowOpacity = 1
            layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(language: Language) {
        self.init(frame: .zero)
        self.language = language
        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
