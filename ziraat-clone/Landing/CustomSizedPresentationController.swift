//
//  HalfSizePresentationController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/28/22.
//

import Foundation
import UIKit

class CustomSizedPresentationController: UIPresentationController {
    var gesture: UITapGestureRecognizer?
    var heightDivider: CGFloat = 3.5
    var dimmedView: UIView!

    func getDimmedView(recognizer: UITapGestureRecognizer?) -> UIView {
        let backdrop = UIView()
        backdrop.backgroundColor = .black.withAlphaComponent(1)
        backdrop.layer.opacity = 0
        backdrop.tag = 99
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.isUserInteractionEnabled = true
        if let gesture = gesture {
            backdrop.addGestureRecognizer(gesture)
        }
        return backdrop
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        let maxY = bounds.height / heightDivider
        let height = bounds.height - maxY
        return CGRect(x: 0, y: maxY, width: bounds.width, height: height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let container = containerView else {
            fatalError("There is no container view")
        }
        dimmedView = getDimmedView(recognizer: gesture)

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
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmedView.layer.opacity = 0
        }, completion: { _ in
            self.dimmedView = nil
        })
    }
}
