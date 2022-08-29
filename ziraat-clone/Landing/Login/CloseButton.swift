//
//  LoginCloseButton.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/29/22.
//

import Foundation
import UIKit

class CloseButton: UIView {
    var onClose: (() -> Void)?
    var imageView: UIImageView!
    var label: UILabel!
    private var stackView: UIStackView!
    
    var axis: NSLayoutConstraint.Axis = .vertical {
        didSet {
            stackView.axis = axis
            if axis == .vertical {
                stackView.alignment = .center
            }
            else {
                stackView.distribution = .fill
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let closeImage = UIImage(systemName: "xmark")
        let closeButtonImageView = UIImageView(image: closeImage)
        closeButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        closeButtonImageView.tintColor = .black
        closeButtonImageView.clipsToBounds = true
        closeButtonImageView.isUserInteractionEnabled = true
        
        closeButtonImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        addGestureRecognizer(closeGesture)
        
        let closeLabel = UILabel()
        closeLabel.translatesAutoresizingMaskIntoConstraints = false
        closeLabel.text = L10n.close_button_text.localized
        closeLabel.adjustsFontForContentSizeCategory = true
        closeLabel.font = .preferredFont(forTextStyle: .subheadline)
        closeLabel.textColor = .black

        closeButtonImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        let stackView = UIStackView(arrangedSubviews: [closeButtonImageView, closeLabel])
        stackView.axis = axis
        stackView.spacing = 5
        if axis == .vertical {
            stackView.alignment = .center
        }
        else {
            stackView.distribution = .fill
        }
        
        addSubview(stackView)
       
        stackView.snp.makeConstraints { make in
            make.top.leading.width.height.equalTo(self)
        }
        
        self.stackView = stackView
        
        
        label = closeLabel
        imageView = closeButtonImageView
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func close() {
        print("close")
        onClose?()
    }
}
