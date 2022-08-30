//
//  CampaignCell.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/29/22.
//

import Foundation
import UIKit

class CampaignCell: UICollectionViewCell {
    var imageView: UIImageView!
    var item: CampaignItem?
    static let identifier = "campaign_cell"

    convenience init(item: CampaignItem) {
        self.init(frame: .zero)
        self.item = item
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
   
    private func setup() {
        let imageView = UIImageView()
        if item != nil {
            imageView.image = UIImage(named: item!.image)
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        imageView.layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        self.imageView = imageView
    }
    
    func configure(with item: CampaignItem) {
        imageView.image = UIImage(named: item.image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
