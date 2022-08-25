//
//  LoginSheetTransitionDelegate.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/19/22.
//

import Foundation
import UIKit

class LoginSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var onClose: (() -> ())?
    var presentingViewController: UIViewController?
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(close))
        let presentationController = HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
        presentationController.gesture = gesture
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard presented is HomePageViewController else {
            return nil
        }
        return MoveUpPageTransition(movement: .up, duration: 2.0)
    }
    
    @objc private func close() {
        onClose?()
    }
}
