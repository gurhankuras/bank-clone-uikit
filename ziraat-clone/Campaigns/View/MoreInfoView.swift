//
//  MoreInfoView.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/30/22.
//

import UIKit

class MoreInfoView: UIView {

    lazy var label: UILabel = makeLabel(text: "Detaylı Bilgi")
    lazy var imageView: UIImageView = makeArrow()
    var isRunning = false
    private var moreInfoAnimator: UIViewPropertyAnimator?

    override init(frame: CGRect) {

        super.init(frame: frame)
        addSubview(label)
        addSubview(imageView)
        label.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        imageView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
        }
    }
    
      func startMoving() {
          isRunning = true
          let options: UIView.AnimationOptions = [.curveEaseInOut, .autoreverse, .repeat]
          UIView.animate(withDuration: 1.4, delay: 0.1, options: options,
                    animations: { [weak self] in self?.label.transform = CGAffineTransform(translationX: 0, y: -10)
                }, completion: nil)
          
          UIView.animate(withDuration: 1.4, delay: 0, options: options,
                        animations: { [weak self] in
                    guard let self = self else { return }
                    let transform = self.imageView.transform .concatenating(.init(translationX: 0, y: -10))
                    self.imageView.transform = transform
                }, completion: nil)
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: View factory functions
extension MoreInfoView {
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .white
        return label
    }
    
    func makeArrow() -> UIImageView {
        let image = UIImage(systemName: "chevron.backward.2")
        let iw = UIImageView(image: image)
        iw.tintColor = .white
        iw.transform = CGAffineTransform(rotationAngle: .pi / 2)
        return iw
    }
}
