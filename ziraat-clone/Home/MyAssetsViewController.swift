//
//  MyAssetsViewController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/24/22.
//

import Foundation
import UIKit

class MyAssetsViewController: UIViewController {
    var circularProgressBarView: AssetsCircularChart!
       var circularViewDuration: TimeInterval = 2
    private let assets = Assets(current: 2, deposit: 1, investment: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        setUpCircularProgressBarView()
        circularProgressBarView.progressAnimation(duration: circularViewDuration)
    }
    
    func setUpCircularProgressBarView() {
        circularProgressBarView = AssetsCircularChart(frame: .zero)
        //circularProgressBarView.backgroundColor = .red.withAlphaComponent(0.4)
        circularProgressBarView.assets = assets
        
        /*
        let r = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 200))
        let maskImage = r.image { ctx in
            let p = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 200, height: 200))
            UIColor.clear.setFill()
            p.fill()
        }
         */
       
        
        view.addSubview(circularProgressBarView)
        
        circularProgressBarView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        let totalLabel = UILabel()
        totalLabel.textColor = .secondaryLabel
        totalLabel.text = "Total"
        
        
        let amountLabel = UILabel()
        amountLabel.textColor = .white
        amountLabel.text = "* * * * TL"
        amountLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        let stack = UIStackView(arrangedSubviews: [totalLabel, amountLabel])
        stack.axis = .vertical
        stack.alignment = .center
        view.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(circularProgressBarView)
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let maskView = UIView()
        
        maskView.backgroundColor = .red //you can modify this to whatever you need
        maskView.frame = CGRect(x: 0, y: 0, width: circularProgressBarView.frame.width, height: circularProgressBarView.frame.height)
        maskView.layer.cornerRadius = 100
        circularProgressBarView.addSubview(maskView)
        circularProgressBarView.mask = maskView

    }
    
    @objc func animateChart() {
        print("animate")
        circularProgressBarView.progressAnimation(duration: circularViewDuration)
    }
}

enum Partition {
    case current, deposit, investment
}
struct Assets {
    let current: CGFloat
    let deposit: CGFloat
    let investment: CGFloat
    
    var total: CGFloat {
        current + deposit + investment
    }
    
    func percent(for partition: Partition) -> CGFloat {
        switch partition {
        case .current:
            return current / total
        case .deposit:
            return deposit / total
        case .investment:
            return investment / total
        }
    }
    
    func cumulativePercent(until partition: Partition) -> CGFloat {
        switch partition {
        case .current:
            return percent(for: .current)
        case .deposit:
            return percent(for: .current) + percent(for: .deposit)
        case .investment:
            return 1
        }
    }
}


