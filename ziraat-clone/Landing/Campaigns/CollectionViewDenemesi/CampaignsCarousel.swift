//
//  CampaignsCarousel.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/30/22.
//

import Foundation
import UIKit

class CampaignsCarousel: UIViewController {
    var collectionView: UICollectionView!
    var items: [CampaignItem] = [.init(id: "1", image: "kampanya", link: nil, select: {_ in }),
                                 .init(id: "2", image: "kampanya2", link: nil, select: {_ in }),
                                 .init(id: "3", image: "kampanya3", link: nil, select: {_ in })]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        view.backgroundColor = .black
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(CampaignsCarouselSlideCell.self, forCellWithReuseIdentifier: CampaignsCarouselSlideCell.cellIdentifier)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
}

extension CampaignsCarousel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return size
    }
}

extension CampaignsCarousel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)

        return self.items.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CampaignsCarouselSlideCell.cellIdentifier, for: indexPath)
                as? CampaignsCarouselSlideCell else {
            fatalError()
        }
        let item = self.items[indexPath.row]
        cell.configure(with: item, onTimeout: {[weak self] in self?.handleTimeout(for: indexPath) })
        //cell.reset()
        //cell.startTimer()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(#function)
        guard let cell = cell as? CampaignsCarouselSlideCell else {
            fatalError()
        }
        
        //cell.reset()
    }
    
    func handleTimeout(for indexPath: IndexPath) {
        dump(indexPath)
        if indexPath.row < self.items.count {
            collectionView.scrollToItem(at: IndexPath(row: indexPath.row + 1, section: 0), at: .centeredHorizontally, animated: true)
        }
        
        
    }
}
