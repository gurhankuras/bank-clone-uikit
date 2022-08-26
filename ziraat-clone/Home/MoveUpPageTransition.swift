//
//  MoveUpPageTransition.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/29/22.
//

import Foundation
import UIKit

class MoveUpPageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    enum MovementType {
        case up, down
    }
    private let movement: MovementType
    private let duration: Double
    init(movement: MovementType, duration: Double) {
        self.duration = duration
        self.movement = movement
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: duration) ?? 0
    }
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let destinationViewController = transitionContext.viewController(forKey: .to),
              let sourceViewController = transitionContext.viewController(forKey: .from),
              let view = transitionContext.view(forKey: .to) else {
                  transitionContext.completeTransition(false)
            return
        }
        
        transitionContext.containerView.addSubview(view)
        translate(view: view, to: self.movement, with: transitionContext)
    }
    
    private func translate(view: UIView, to direction: MovementType, with context: UIViewControllerContextTransitioning) {
        view.clipsToBounds = true
        view.transform = CGAffineTransform(translationX: 0, y: movement == .up ?   context.containerView.frame.size.height : 0)
        
        let duration = transitionDuration(using: context)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else {
                context.completeTransition(false)
                return
            }
            view.transform = CGAffineTransform(translationX: 0, y: self.movement == .up ? 0 : context.containerView.frame.size.height)
        } completion: { _ in
            context.completeTransition(true)
        }
    }
    
    
}
