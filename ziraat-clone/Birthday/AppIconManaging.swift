//
//  AppIconManaging.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/11/22.
//

import Foundation

protocol AppIconManaging {
    var currentIcon: AppIcon? { get }
    func `switch`(to icon: AppIcon, completion: @escaping (Error?) -> Void)
}
