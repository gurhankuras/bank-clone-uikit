//
//  UIColor+Color.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/24/22.
//

import Foundation
import UIKit

extension UIColor {
    static let chartBlue = UIColor(red: 33/255, green: 145/255, blue: 253/255, alpha: 1)
    static let chartOrange = UIColor(red: 255/255, green: 217/255, blue: 48/255, alpha: 1)
    static let chartGreen = UIColor(rgb: (86, 177, 101))
    static let primary = UIColor(rgb: (225, 4, 19))

    
    convenience init(rgb: (Int, Int, Int), alpha: CGFloat = 1) {
        self.init(red: CGFloat(rgb.0) / 255, green: CGFloat(rgb.1) / 255, blue: CGFloat(rgb.2) / 255, alpha: alpha)
    }

}
