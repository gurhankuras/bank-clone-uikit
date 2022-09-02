//
//  SlideToolBar.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation
import UIKit

class SlideToolBar: UIView {
    // MARK: Views
    private let timeBarBackground = UIView()
    lazy var timeBar: UIView = makeTimeBar()
    lazy var iconDisplay: UIImageView = makeIconImageView(imageUrl: self.imageUrl!)
    lazy var closeButton: UIButton = makeCloseButton()
    let stack = UIStackView()
    let gradientView = UIView()
    
    var gradientLayer: CAGradientLayer?
    private var animator: UIViewPropertyAnimator?
    
    // MARK: Constructor Parameters
    var imageUrl: String?
    var onClose: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(imageUrl: String, onClose: @escaping () -> Void) {
        self.init(frame: .zero)
        self.imageUrl = imageUrl
        self.onClose = onClose
        iconDisplay = makeIconImageView(imageUrl: self.imageUrl!)
        timeBarBackground.backgroundColor = .gray
        addSubview(gradientView)
        addSubview(timeBarBackground)
        addSubview(timeBar)
        addSubview(iconDisplay)
        addSubview(closeButton)
        addSubview(stack)
        setupConstraints()
    }
    
    private func setupConstraints() {
        timeBarBackground.snp.makeConstraints { make in
            make.width.equalTo(self).multipliedBy(0.95)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(2)
        }
        
        timeBar.snp.makeConstraints { make in
            make.width.equalTo(timeBarBackground.snp.width).multipliedBy(0)
            make.leading.equalTo(timeBarBackground.snp.leading)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(2)
        }
        
        gradientView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(self)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stack.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.top.equalTo(timeBarBackground.snp.bottom)
            make.bottom.equalToSuperview()
        }
        stack.addArrangedSubview(iconDisplay)
        stack.addArrangedSubview(closeButton)
        
        iconDisplay.snp.makeConstraints { make in
            make.height.equalTo(self).multipliedBy(0.65)
            make.width.equalTo(self.snp.height).multipliedBy(0.65)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientLayer == nil {
            addGradient()
        }
        gradientLayer?.frame = gradientView.bounds
    }
    
    @objc func finish() {
        onClose?()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Animation
extension SlideToolBar {
    func startTimer(duration: TimeInterval, completion: @escaping () -> Void) {
        guard animator == nil else { return }
        self.layoutIfNeeded()
        timeBar.snp.remakeConstraints { make in
            make.width.equalTo(timeBarBackground.snp.width).multipliedBy(1)
            make.leading.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(2)
        }
        animator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            self?.layoutIfNeeded()
        }
        animator?.addCompletion { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
        animator?.startAnimation()
    }
    
    func reset() {
        animator?.stopAnimation(true)
        animator = nil
        
        timeBar.snp.remakeConstraints { make in
            make.width.equalTo(timeBarBackground.snp.width).multipliedBy(0)
            make.leading.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(2)
        }
        self.layoutIfNeeded()
    }
}

// MARK: View factory functions
extension SlideToolBar {
    func makeTimeBar() -> UIView {
        let bar = UIView()
         bar.backgroundColor = .white
         return bar
    }
    
    func makeIconImageView(imageUrl: String) -> UIImageView {
        let image = UIImage(named: imageUrl)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }
    
    func makeCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(finish), for: .touchUpInside)
        return button
    }
}

// MARK: Gradient
extension SlideToolBar {
    private func addGradient() {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.withAlphaComponent(0.6).cgColor,
                                UIColor.black.withAlphaComponent(0.2).cgColor]
        layer.frame = gradientView.bounds
        gradientView.layer.addSublayer(layer)
        gradientLayer = layer
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SlideToolBar_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
           let v = SlideToolBar(imageUrl: "kampanya", onClose: {})
            v.iconDisplay.layer.cornerRadius = 20
            return v
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 350, height: 60, alignment: .leading)
        .ignoresSafeArea()
    }
}
#endif
