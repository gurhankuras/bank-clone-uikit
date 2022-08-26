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
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(close))
        let presentationController = CustomSizedPresentationController(presentedViewController: presented, presenting: presenting)
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


class LanguageSelectionTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var onClose: (() -> ())?
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(close))
        let presentationController = CustomSizedPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.heightDivider = 1.15
        presentationController.gesture = gesture
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    @objc private func close() {
        onClose?()
    }
}
