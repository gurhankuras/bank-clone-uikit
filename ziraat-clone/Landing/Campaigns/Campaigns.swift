//
//  CampaignsCollectionView.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/29/22.
//

import Foundation
import UIKit

class CampaignCell: UICollectionViewCell {
    var imageView: UIImageView!
    var imageUrl: String?
    static let identifier = "campaign_cell"
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(frame: .zero)
        self.setup(with: imageUrl)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(with: nil)
    }
    
    private func setup(with imageUrl: String?) {

        let imageView = UIImageView(image: UIImage(named: imageUrl ?? ""))
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
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Campaigns: UIViewController {
    weak var collectionView: UICollectionView!

    override func loadView() {
        super.loadView()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cv)
        cv.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        self.collectionView = cv
         

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.backgroundColor = .yellow
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CampaignCell.self, forCellWithReuseIdentifier: CampaignCell.identifier)
         
    }
}


extension Campaigns: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.greatestFiniteMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
        }
 
    
}

extension Campaigns: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CampaignCell.identifier, for: indexPath) as? CampaignCell else {
            fatalError()
        }
        cell.imageView.image = UIImage(named: "kampanya")
        return cell
    }
    
    
}
 
