//
//  UIViewControllerPreview.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import UIKit

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        viewController
    }
    
    typealias UIViewControllerType = ViewController
    let viewController: ViewController
    
    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }
    
   
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        return
    }
    
}
#endif
