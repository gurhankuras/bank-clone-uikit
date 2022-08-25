//
//  UserSwitch.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/28/22.
//

import Foundation
import UIKit
import SnapKit

class UserAvatar: UIView {
    var cornerRadius: CGFloat = 0
    var bigCircleView: UIView!
    var miniCircle: UIView!
    private static let circleRatio = 0.4
    private static let iconCoverage = 0.6
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    
    convenience init(cornerRadius: CGFloat, showsMiniIcon: Bool, frame: CGRect) {
        self.init(frame: frame)
        self.cornerRadius = cornerRadius
        
        
        bigCircleView = UIView()
        bigCircleView.backgroundColor = .darkGray
        bigCircleView.translatesAutoresizingMaskIntoConstraints = false
        //bigCircleView.layer.cornerRadius = self.cornerRadius
        
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        bigCircleView.addSubview(imageView)
        addSubview(bigCircleView)
        

        bigCircleView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(bigCircleView).multipliedBy(Self.iconCoverage)
            make.width.equalTo(bigCircleView).multipliedBy(Self.iconCoverage)
            make.centerY.centerX.equalTo(bigCircleView)
        }
        
        if showsMiniIcon {
            miniCircle = UIView()
            miniCircle.translatesAutoresizingMaskIntoConstraints = false
            miniCircle.backgroundColor = .white
            miniCircle.translatesAutoresizingMaskIntoConstraints = false
            
            miniCircle.layer.borderWidth = 1
            miniCircle.layer.borderColor = UIColor.gray.cgColor
            
            let miniCircleImageView = UIImageView(image: UIImage(systemName: "person"))
            miniCircleImageView.tintColor = .black
            miniCircleImageView.translatesAutoresizingMaskIntoConstraints = false
            
            miniCircle.addSubview(miniCircleImageView)
            bigCircleView.addSubview(miniCircle)
            
            miniCircle.snp.makeConstraints { make in
                make.trailing.equalTo(bigCircleView)
                make.width.equalTo(bigCircleView.snp.width).multipliedBy(Self.circleRatio)
                make.height.equalTo(bigCircleView.snp.height).multipliedBy(Self.circleRatio)
                make.bottom.equalTo(bigCircleView)
            }
            
            miniCircleImageView.snp.makeConstraints { make in
                make.height.equalTo(miniCircle).multipliedBy(Self.iconCoverage)
                make.width.equalTo(miniCircle).multipliedBy(Self.iconCoverage)
                make.centerY.centerX.equalTo(miniCircle)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let a = bigCircleView.frame.width
        bigCircleView.layer.cornerRadius = max(bigCircleView.frame.width, bigCircleView.frame.height) / 2
        if let miniCircle = miniCircle {
            miniCircle.layer.cornerRadius = max(bigCircleView.frame.width * Self.circleRatio, bigCircleView.frame.height * Self.circleRatio) / 2
        }
        

        print("layout")
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
