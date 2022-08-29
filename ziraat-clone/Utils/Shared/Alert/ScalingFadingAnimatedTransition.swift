//
//  ScalingFadingAnimatedTransitioning.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/28/22.
//

import Foundation
import UIKit

class ScalingFadingAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: Double
    private let type: AnimationType
    
    init(duration: Double, for type: AnimationType = .present) {
        self.duration = duration
        self.type = type
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: duration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
                  transitionContext.completeTransition(false)
            return
        }
        
        switch type {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            present(view: toViewController.view, with: transitionContext)
        case .dismiss:
            transitionContext.containerView.addSubview(fromViewController.view)
            dismiss(view: fromViewController.view, with: transitionContext)
        }
    }
    private func present(view: UIView, with context: UIViewControllerContextTransitioning) {
        //view.clipsToBounds = true
        view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        view.alpha = 0
        let duration = transitionDuration(using: context)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0) {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
            view.alpha = 1
        } completion: { _ in
            context.completeTransition(true)
        }
    }
    
    
    private func dismiss(view: UIView, with context: UIViewControllerContextTransitioning) {
        //view.clipsToBounds = true
        view.alpha = 1
        let duration = transitionDuration(using: context)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            view.alpha = 0
        } completion: { _ in
            context.completeTransition(true)
        }
    }
}

extension ScalingFadingAnimatedTransition {
    enum AnimationType {
        case present
        case dismiss
    }
}
