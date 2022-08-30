//
//  CampaignsCarouselSlideCell.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/30/22.
//

import Foundation
import UIKit

class CampaignsCarouselSlideCell: UICollectionViewCell {
    static let cellIdentifier = "carouselcell"
    var item: CampaignItem?
    let duration: TimeInterval = 5.0
    var onTimeout: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAndLayoutViews()
    }
    
    convenience init(item: CampaignItem, onTimeout: (() -> Void)?) {
        self.init(frame: .zero)
        self.item = item
        self.onTimeout = onTimeout
        addAndLayoutViews()
      
    }
    
    private func addAndLayoutViews() {
        addSubviews()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        //recognizer.delegate = self
        recognizer.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(recognizer)
        timeBarBackground.backgroundColor = .gray
    
        topBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        gradientView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(contentView)
            make.bottom.equalTo(topBar.snp.bottom)
        }
        
        bodyImageView.snp.makeConstraints { make in
            make.top.equalTo(timeBar.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalTo(contentView)
        }
        
        timeBarBackground.snp.makeConstraints { make in
            make.width.equalTo(contentView).multipliedBy(0.95)
            make.centerX.equalTo(contentView)
            make.top.equalTo(topBar.snp.bottom).offset(10)
            make.height.equalTo(2)
        }
       
        timeBar.snp.makeConstraints { make in
            make.width.equalTo(timeBarBackground.snp.width).multipliedBy(0)
            make.leading.equalTo(timeBarBackground.snp.leading)
            make.top.equalTo(topBar.snp.bottom).offset(10)
            make.height.equalTo(2)
        }
         
        /*
        NSLayoutConstraint.activate([
            timeBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            timeBar.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 10),
            timeBar.heightAnchor.constraint(equalToConstant: 2)
        ])
       
        widthContraint = timeBar.widthAnchor.constraint(equalTo: timeBarBackground.widthAnchor, multiplier: 0)
        widthContraint?.isActive = true
*/
        iconDisplay.snp.makeConstraints { make in
            make.leading.equalTo(topBar).offset(20.0)
            make.centerY.equalTo(topBar)
            make.height.equalTo(topBar).multipliedBy(0.75)
            make.width.equalTo(topBar.snp.height).multipliedBy(0.75)
        }
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(topBar).inset(8.0)
            make.centerY.equalTo(topBar)
            make.height.equalTo(topBar).multipliedBy(1)
            make.width.equalTo(topBar.snp.height).multipliedBy(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { log_deinit(Self.self) }
    lazy var timeBar: UIView = {
       let bar = UIView()
        bar.backgroundColor = .white
        return bar
    }()
    
    lazy var topBar: UIView = {
        let bar = UIView()
        return bar
    }()
    
    var tapped = false
    
    lazy var iconDisplay: UIImageView = {
        let imageView = UIImageView()

        if let item = item {
            let image = UIImage(named: item.image)
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor

        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(finish), for: .touchUpInside)
        return button
    }()
    
    lazy var bodyImageView: UIImageView = {
        let imageView = UIImageView()

        if let item = item {
            let image = UIImage(named: item.image)
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gradientView = UIView()
    private let timeBarBackground = UIView()
    private var gradientLayer: CAGradientLayer?
    private var animator: UIViewPropertyAnimator?
    
    var widthContraint: NSLayoutConstraint?
    
    private func addSubviews() {
        contentView.addSubview(gradientView)
        contentView.addSubview(topBar)
        contentView.addSubview(timeBarBackground)
        contentView.addSubview(timeBar)
        topBar.addSubview(iconDisplay)
        topBar.addSubview(closeButton)
        contentView.addSubview(bodyImageView)
    }
    
    func configure(with item: CampaignItem, onTimeout: @escaping (() -> Void)) {
        self.item = item
        self.onTimeout = onTimeout
        bodyImageView.image = UIImage(named: item.image)
        iconDisplay.image = UIImage(named: item.image)
    }
    
    @objc func tap() {
        reset()
        onTimeout?()
    }
    
    /*
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        iconDisplay.layer.cornerRadius = iconDisplay.frame.width / 2
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if gradientLayer == nil {
            addGradient()
        }
        gradientLayer?.frame = gradientView.bounds
        timeBar.layer.cornerRadius = timeBar.frame.height / 2
        timeBarBackground.layer.cornerRadius = timeBar.frame.height / 2
        
    }
     */
    
    private func addGradient() {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.withAlphaComponent(0.6).cgColor,
                                UIColor.black.withAlphaComponent(0.2).cgColor]
        layer.frame = gradientView.bounds
        gradientView.layer.addSublayer(layer)
        gradientLayer = layer
    }
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
        print("viewDidAppear")
    }
     */
    
    func startTimer() {
        guard animator == nil else { return }
        self.layoutIfNeeded()
        /*
        widthContraint?.isActive = false
        widthContraint = timeBar.widthAnchor.constraint(equalTo: timeBarBackground.widthAnchor, multiplier: 1)
        widthContraint?.isActive = true
        */
         
        timeBar.snp.remakeConstraints { make in
            make.width.equalTo(timeBarBackground.snp.width).multipliedBy(1)
            make.leading.equalTo(self).offset(10)
            make.top.equalTo(topBar.snp.bottom).offset(10)
            make.height.equalTo(2)
        }
         
        self.setNeedsLayout()
        /*
        animator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            self?.layoutIfNeeded()
        }
        animator?.addCompletion { [weak self] _ in
            print("completion")
            self?.onTimeout?()
        }
        print("starting animation")
        animator?.startAnimation()
         */
    
    }
    
    func reset() {
        animator?.stopAnimation(true)
        animator = nil
        
        timeBar.snp.remakeConstraints { make in
            make.width.equalTo(timeBarBackground.snp.width).multipliedBy(0)
            make.leading.equalTo(self).offset(10)
            make.top.equalTo(topBar.snp.bottom).offset(10)
            make.height.equalTo(2)
        }
        self.layoutIfNeeded()
    }
    
    @objc func finish() {
        print("finish")
        //self.navigationController?.popViewController(animated: true)
    }
}
