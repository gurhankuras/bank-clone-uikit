//
//  UIEdgeInsets+all.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/27/22.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    static func all(_ inset: CGFloat) -> Self {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    static func symmetric(_ axis: NSLayoutConstraint.Axis, inset: CGFloat) -> Self {
        switch axis {
        case .vertical:
            return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        case .horizontal:
            return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        @unknown default:
            fatalError()
        }
    }
}
