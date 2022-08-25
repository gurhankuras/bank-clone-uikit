//
//  LoginCloseButton.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/29/22.
//

import Foundation
import UIKit

class LoginSheetCloseButton: UIView {
    var onClose: (() -> Void)?
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let closeImage = UIImage(systemName: "xmark")
        let closeButtonImageView = UIImageView(image: closeImage)
        closeButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        closeButtonImageView.tintColor = .black
        closeButtonImageView.isUserInteractionEnabled = true
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        addGestureRecognizer(closeGesture)
        
        let closeLabel = UILabel()
        closeLabel.translatesAutoresizingMaskIntoConstraints = false
        closeLabel.text = "Close"
        closeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        closeLabel.textColor = .black
        
        addSubview(closeLabel)
        closeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.centerX.equalTo(snp.centerX)
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
        }
        
        addSubview(closeButtonImageView)
        
        closeButtonImageView.snp.makeConstraints { make in
            make.bottom.equalTo(closeLabel.snp.top).offset(-6)
            make.centerX.equalTo(snp.centerX)
            
            make.top.equalTo(snp.top)
        }
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
