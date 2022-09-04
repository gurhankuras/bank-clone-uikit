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

class CampaignCarouselSlide: UIViewController {
    var item: CampaignViewModel!
    let duration: TimeInterval = 2.0
    var onTimeout: (() -> Void)?
    var onExit: (() -> Void)?
    
    var moreInfoLabel: MoreInfoView?
    lazy var toolBar = SlideToolBar(imageUrl: item.image, onClose: { [weak self] in self?.onExit?()})
    lazy var bodyImageView: UIImageView = makeBodyImageView(imageUrl: self.item.image)
    
    var browserOpen: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(item: CampaignViewModel, onTimeout: (() -> Void)?) {
        self.init(nibName: nil, bundle: nil)
        self.item = item
        self.onTimeout = onTimeout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { log_deinit(Self.self) }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .black
    }

    private func addSubviews() {
        view.addSubview(bodyImageView)
        view.addSubview(toolBar)
        if item.hasLink {
            let v = MoreInfoView()
            view.addSubview(v)
            moreInfoLabel = v
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        
        if item.hasLink {
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
            recognizer.delegate = self
            bodyImageView.addGestureRecognizer(recognizer)
        }
        setConstraints()
    }
    
    private func setConstraints() {
        toolBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        bodyImageView.snp.makeConstraints { make in
            make.top.equalTo(toolBar.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalTo(view)
        }
        if item.hasLink {
            moreInfoLabel?.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide)
                make.centerX.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        toolBar.iconDisplay.layer.cornerRadius = toolBar.iconDisplay.frame.width / 2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toolBar.startTimer(duration: duration, completion: { [weak self] in self?.onTimeout?() })
        if let v = moreInfoLabel, !v.isRunning {
            v.startMoving()
        }
        print("viewDidAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        toolBar.reset()
    }
    
    @objc func finish() {
        print("finish")
        onExit?()
    }
}

// MARK: Open link on safari by gesture
extension CampaignCarouselSlide {
    @objc func pan(_ p: UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in: v.superview)
            let degree = revisedDegree(delta: delta, by: 90)
            let activeDegreeRange: ClosedRange<CGFloat> = (-30...30)
            print("degree: \(degree)")

            if item.hasLink && activeDegreeRange.contains(degree) && !browserOpen {
                browserOpen = true
                openSafari(with: item.link!)
            }
        default:
            break
        }
    }
    
    private func revisedDegree(delta: CGPoint, by substitudeDegree: CGFloat) -> CGFloat {
        return (atan2(delta.y, delta.x) * 180 / .pi) + substitudeDegree
    }
    
    private func openSafari(with url: String) {
        let config = SFSafariViewController.Configuration()
        let svc = SFSafariViewController(url: URL(string: url)!, configuration: config)
        svc.delegate = self
        svc.modalPresentationStyle = .formSheet
        self.present(svc, animated: true)
    }
}

// MARK: view factory methods
extension CampaignCarouselSlide {
    private func makeBodyImageView(imageUrl: String) -> UIImageView {
        let image = UIImage(named: imageUrl)
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
}

extension CampaignCarouselSlide: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CampaignCarouselSlide: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("DONE")
        browserOpen = false
    }
}

extension CampaignCarouselSlide: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("DONE swiping")
        browserOpen = false
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .formSheet
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CampaignPageViewControllerSlide_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let vm = CampaignViewModel(id: "1", image: "kampanya", link: "", read: false)
            let vc = CampaignCarouselSlide(item: vm, onTimeout: {})
            return vc
        }
        .ignoresSafeArea()
    }
}
#endif
