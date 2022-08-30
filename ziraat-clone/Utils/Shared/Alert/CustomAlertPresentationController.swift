//
//  CustomAlertPresentationController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/27/22.
//

import Foundation
import UIKit
import OSLog

// .centeredRectOfSize(.init(width: max(300, frame.size.width), height: frame.size.height))

class CustomAlertPresentationController: UIPresentationController {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: "CustomAlertPresentationController"))

    var dimmedView: UIView!

    func getDimmedView() -> UIView {
        let backdrop = UIView()
        backdrop.backgroundColor = .black.withAlphaComponent(1)
        backdrop.layer.opacity = 0
        backdrop.tag = 99
        backdrop.translatesAutoresizingMaskIntoConstraints = false

        return backdrop
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        // delegate = self
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
            let presentedView = presentedView else { return .zero }

        let horizontalInset: CGFloat = 15
        let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        let targetWidth = safeAreaFrame.width - 2 * horizontalInset
        let fittingSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)

        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height

        var frame = safeAreaFrame
        frame.origin.x = horizontalInset + containerView.safeAreaInsets.left
        frame.origin.y = (safeAreaFrame.height - targetHeight) / 2
        frame.size.width = targetWidth
        frame.size.height = targetHeight

        let maxWidth: CGFloat = 350
        if targetWidth > maxWidth {
            frame.size.width = maxWidth
            frame.origin.x += (targetWidth - maxWidth) / 2
        }
        return frame
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let container = containerView else {
            fatalError("There is no container view")
        }
        dimmedView = getDimmedView()

        container.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.edges.equalTo(container)
        }

        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmedView.layer.opacity = 0.5
        })
        print("willbegin")
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        // guard let avatar = containerView?.subviews.filter({ $0.tag == 99 }).first else { return }
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmedView?.layer.opacity = 0
        }, completion: { _ in
            self.dimmedView.removeFromSuperview()
            self.dimmedView = nil
        })
    }
}
