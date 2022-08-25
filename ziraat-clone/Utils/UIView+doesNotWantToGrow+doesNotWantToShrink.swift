//
//  UIView+doesNotWantToGrow+doesNotWantToShrink.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/30/22.
//

import Foundation
import UIKit

extension UIView {
    func doesNotWantToGrow(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(priority, for: axis)
    }
    
    func doesNotWantToShrink(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentCompressionResistancePriority(priority, for: axis)
    }
}
