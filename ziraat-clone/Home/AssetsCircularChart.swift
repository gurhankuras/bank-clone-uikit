//
//  AssetsCircularChart.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/24/22.
//

import Foundation
import UIKit

class AssetsCircularChart: UIView {
    private var shapeLayers = [CAShapeLayer(), CAShapeLayer(), CAShapeLayer()]
    private var centerCircle = CAShapeLayer()

    var totalDuration: TimeInterval = 0.8
    var interDelay: TimeInterval?
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    var assets: Assets! {
        didSet {
            percentages = [assets.percent(for: .current), assets.percent(for: .deposit), assets.percent(for: .investment)]
        }
    }
    private var percentages: [CGFloat]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers = []
        let lineWidth: CGFloat = 25.0
        let minAxis = min(rect.width, rect.height)
        let radius = (minAxis / 2) - (lineWidth / 2)
        let rectCenter = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
      
        drawCenterCircle(center: rectCenter, radius: (minAxis / 2) - lineWidth)
        
        var endAngle: CGFloat = startPoint
        var startAngle: CGFloat = startPoint
        let partitions: [Partition] = [.current, .deposit, .investment]
        
        zip(shapeLayers, zip(partitions, [UIColor.chartOrange, UIColor.chartBlue, UIColor.chartGreen]))
            .forEach { (shapeLayer, partition) in
                startAngle = endAngle
                endAngle = endAngle + (2 * .pi * (assets.percent(for: partition.0)))
                print("start: \(startAngle), end: \(endAngle)")
                
                let path = UIBezierPath(arcCenter: rectCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                shapeLayer.path = path.cgPath
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.lineCap = .butt
                shapeLayer.lineWidth = lineWidth
                shapeLayer.strokeStart = 0
                shapeLayer.strokeEnd = 0
                shapeLayer.strokeColor = partition.1.cgColor
                self.layer.addSublayer(shapeLayer)
            }
    }
    
    private func drawCenterCircle(center: CGPoint, radius: CGFloat) {
        centerCircle.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
        centerCircle.fillColor = UIColor.black.withAlphaComponent(0.15).cgColor
        layer.addSublayer(centerCircle)
    }
    
    func progressAnimation(duration: TimeInterval) {
        shapeLayers.forEach({ $0.removeAllAnimations() })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            var delay: CGFloat = 0
            self.shapeLayers.enumerated().forEach { index, shapeLayer in
                let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
                animation.duration = self.percentages[index] * self.totalDuration
                animation.beginTime = CACurrentMediaTime() + delay
                animation.toValue = 1
                animation.fillMode = .forwards
                animation.isRemovedOnCompletion = false
                shapeLayer.add(animation, forKey: nil)
                delay += animation.duration
                if let interDelay = self.interDelay {
                    delay += interDelay
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
let firstEndAngle = startPoint + (2 * .pi * (assets.percent(for: .current)))
let firstPath = UIBezierPath(arcCenter: rectCenter, radius: radius, startAngle: startPoint, endAngle: firstEndAngle, clockwise: true)

currentPartitionLayer.path = firstPath.cgPath
currentPartitionLayer.fillColor = UIColor.clear.cgColor
currentPartitionLayer.lineCap = .butt
currentPartitionLayer.lineWidth = lineWidth
currentPartitionLayer.strokeStart = 0
currentPartitionLayer.strokeEnd = 0
currentPartitionLayer.strokeColor = UIColor.chartBlue.cgColor
layer.addSublayer(currentPartitionLayer)


let secondEndAngle = firstEndAngle + (2 * .pi * assets.percent(for: .deposit))
let secondPath = UIBezierPath(arcCenter: rectCenter, radius: radius, startAngle: firstEndAngle, endAngle: secondEndAngle, clockwise: true)

depositPartitionLayer.path = secondPath.cgPath
depositPartitionLayer.fillColor = UIColor.clear.cgColor
depositPartitionLayer.lineCap = .butt
depositPartitionLayer.lineWidth = lineWidth
depositPartitionLayer.strokeStart = 0
depositPartitionLayer.strokeEnd = 0
depositPartitionLayer.strokeColor = UIColor.chartOrange.cgColor
layer.addSublayer(depositPartitionLayer)

let thirdPath = UIBezierPath(arcCenter: rectCenter, radius: radius, startAngle: secondEndAngle, endAngle: secondEndAngle + (2 * .pi * (assets.percent(for: .investment))),
                                clockwise: true)
investPartitionLayer.path = thirdPath.cgPath
investPartitionLayer.fillColor = UIColor.clear.cgColor
investPartitionLayer.lineCap = .butt
investPartitionLayer.lineWidth = lineWidth
investPartitionLayer.strokeStart = 0
investPartitionLayer.strokeEnd = 0
investPartitionLayer.strokeColor = UIColor.chartGreen.cgColor
layer.addSublayer(investPartitionLayer)
 */


/*
let currentAccountProgressAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
currentAccountProgressAnimation.duration = self.totalDuration
currentAccountProgressAnimation.toValue = 1
currentAccountProgressAnimation.fillMode = .forwards
currentAccountProgressAnimation.isRemovedOnCompletion = false
self.currentPartitionLayer.add(currentAccountProgressAnimation, forKey: nil)


let secondAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
secondAnimation.duration = self.totalDuration
secondAnimation.toValue = 1
secondAnimation.beginTime = CACurrentMediaTime() + currentAccountProgressAnimation.duration
secondAnimation.fillMode = .forwards
secondAnimation.isRemovedOnCompletion = false
self.depositPartitionLayer.add(secondAnimation, forKey: nil)


let thirdAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
thirdAnimation.duration = self.totalDuration
thirdAnimation.toValue = 1
thirdAnimation.beginTime = CACurrentMediaTime() + currentAccountProgressAnimation.duration + secondAnimation.duration
thirdAnimation.fillMode = .forwards
thirdAnimation.isRemovedOnCompletion = false
self.investPartitionLayer.add(thirdAnimation, forKey: nil)
 */
