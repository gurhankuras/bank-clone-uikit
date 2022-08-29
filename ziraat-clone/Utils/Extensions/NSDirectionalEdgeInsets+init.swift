//
//  NSDirectionalEdgeInsets+init.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/31/22.
//

import Foundation
import UIKit

extension NSDirectionalEdgeInsets {
    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
