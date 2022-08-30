//
//  CampaignCarouselPageViewController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/29/22.
//

import Foundation
import UIKit
import SnapKit
import SafariServices



class CampaignPageViewControllerSlide: UIViewController {
    var item: CampaignItem!
    let duration: TimeInterval = 8.0
    var onTimeout: (() -> Void)?
    var onExit: (() -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(item: CampaignItem, onTimeout: (() -> Void)?) {
        self.init(nibName: nil, bundle: nil)
        self.item = item
        self.onTimeout = onTimeout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { log_deinit(Self.self) }
    
    lazy var topBar: UIView = {
        let bar = UIView()
        return bar
    }()
    
    lazy var iconDisplay: UIImageView = makeIconImageView(imageUrl: self.item.image)
    lazy var moreInfoLabel = MoreInfoView()
    lazy var bodyImageView: UIImageView = makeBodyImageView(imageUrl: self.item.image)
    lazy var closeButton: UIButton = makeCloseButton()
    lazy var timeBar: UIView = makeTimeBar()

    
    private let gradientView = UIView()
    private let timeBarBackground = UIView()
    private var gradientLayer: CAGradientLayer?
    private var animator: UIViewPropertyAnimator?
    
    var widthContraint: NSLayoutConstraint?
    var animationStarted = false
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .black
    }

    private func addSubviews() {
        view.addSubview(gradientView)
        view.addSubview(topBar)
        view.addSubview(timeBarBackground)
        view.addSubview(timeBar)
        topBar.addSubview(iconDisplay)
        topBar.addSubview(closeButton)
        view.addSubview(bodyImageView)
        view.addSubview(moreInfoLabel)
    }
    
    var browserOpen: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        recognizer.delegate = self
        bodyImageView.addGestureRecognizer(recognizer)

        timeBarBackground.backgroundColor = .gray
        setConstraints()
    }
    
    private func setConstraints() {
        topBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        gradientView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(view)
            make.bottom.equalTo(topBar.snp.bottom)
        }
        
        bodyImageView.snp.makeConstraints { make in
            make.top.equalTo(timeBar.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalTo(view)
        }
        
        timeBarBackground.snp.makeConstraints { make in
            make.width.equalTo(view).multipliedBy(0.95)
            make.centerX.equalTo(view)
            make.top.equalTo(topBar.snp.bottom).offset(10)
            make.height.equalTo(2)
        }
        
        timeBar.snp.makeConstraints { make in
            make.width.equalTo(timeBarBackground.snp.width).multipliedBy(0)
            make.leading.equalTo(timeBarBackground.snp.leading)
            make.top.equalTo(topBar.snp.bottom).offset(10)
            make.height.equalTo(2)
        }
         
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
        
        moreInfoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        iconDisplay.layer.cornerRadius = iconDisplay.frame.width / 2
    }
    
    
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("didLayout")
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startTimer()
        if !moreInfoLabel.isRunning {
            moreInfoLabel.startMoving()
        }
        print("viewDidAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reset()
    }
    
    @objc func finish() {
        print("finish")
        onExit?()
    }
}

// MARK: Animation
extension CampaignPageViewControllerSlide {
    func startTimer() {
        guard animator == nil,
              !animationStarted else { return }

        self.view.layoutIfNeeded()

        timeBar.snp.remakeConstraints { make in
            make.width.equalTo(timeBarBackground.snp.width).multipliedBy(1)
            make.leading.equalTo(view).offset(10)
            make.top.equalTo(topBar.snp.bottom).offset(10)
            make.height.equalTo(2)
        }

        animator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator?.addCompletion { [weak self] _ in
            print("completion")
            DispatchQueue.main.async {
                self?.onTimeout?()
            }
        }
        print("starting animation")
        animator?.startAnimation()
    }
    
    func reset() {
        animator?.stopAnimation(true)
        animator = nil
        
        timeBar.snp.remakeConstraints { make in
            make.width.equalTo(timeBarBackground.snp.width).multipliedBy(0)
            make.leading.equalTo(view).offset(10)
            make.top.equalTo(topBar.snp.bottom).offset(10)
            make.height.equalTo(2)
        }
         
        self.view.layoutIfNeeded()
    }
}

// MARK: Open link on safari by gesture
extension CampaignPageViewControllerSlide {
    @objc func pan(_ p: UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in: v.superview)
            let degree = revisedDegree(delta: delta, by: 90)
            print("degree: \(degree)")

            if (-30...30).contains(degree) && !browserOpen {
                browserOpen = true
                openSafari()
            }
        default:
            break
        }
    }
    
    private func revisedDegree(delta: CGPoint, by substitudeDegree: CGFloat) -> CGFloat {
        return (atan2(delta.y, delta.x) * 180 / .pi) + substitudeDegree
    }
    
    private func openSafari() {
        let config = SFSafariViewController.Configuration()
        let svc = SFSafariViewController(url: URL(string: "https://www.google.com")!, configuration: config)
        svc.delegate = self
        svc.modalPresentationStyle = .formSheet
        self.present(svc, animated: true)
    }
}

// MARK: view factory methods
extension CampaignPageViewControllerSlide {
    func makeIconImageView(imageUrl: String) -> UIImageView {
        let image = UIImage(named: imageUrl)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }
    
    func makeBodyImageView(imageUrl: String) -> UIImageView {
        let image = UIImage(named: imageUrl)
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
    
    func makeCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(finish), for: .touchUpInside)
        return button
    }
    
    func makeTimeBar() -> UIView {
        let bar = UIView()
         bar.backgroundColor = .white
         return bar
    }
}

extension CampaignPageViewControllerSlide: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension CampaignPageViewControllerSlide: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("DONE")
        browserOpen = false
    }
}

extension CampaignPageViewControllerSlide: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("DONE swiping")
        browserOpen = false
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .formSheet
    }
}

