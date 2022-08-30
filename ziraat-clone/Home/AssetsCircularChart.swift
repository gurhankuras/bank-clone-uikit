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
                endAngle += (2 * .pi * (assets.percent(for: partition.0)))
                // print("start: \(startAngle), end: \(endAngle)")

                let path = UIBezierPath(arcCenter: rectCenter, radius: radius,
                                        startAngle: startAngle, endAngle: endAngle, clockwise: true)
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
        centerCircle.path = UIBezierPath(arcCenter: center, radius: radius,
                                         startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
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
