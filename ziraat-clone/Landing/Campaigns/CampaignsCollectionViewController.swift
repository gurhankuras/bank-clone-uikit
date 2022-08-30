//
//  CampaignsCollectionView.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/29/22.
//

import Foundation
import UIKit

class CampaignsCollectionViewController: UIViewController {
    var collectionView: UICollectionView!
    var items: [CampaignItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = makeItems()
        prepareCollectionView()

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func makeItems() -> [CampaignItem] {
        return [
            CampaignItem(id: "1", image: "kampanya2", link: nil, select: { [weak self] in self?.select($0) }),
            CampaignItem(id: "2", image: "kampanya", link: nil, select: { [weak self] in self?.select($0) }),
            CampaignItem(id: "3", image: "kampanya3", link: nil, select: { [weak self] in self?.select($0) })
        ]
    }
    
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CampaignCell.self,
                                forCellWithReuseIdentifier: CampaignCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    func select(_ item: CampaignItem) {
        let vc = CustomPageViewController(items: self.items, startItem: item)
        vc.onExit = { [weak self] in self?.navigationController?.popViewController(animated: true)}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Layout Delegate
extension CampaignsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items[indexPath.row].select?(items[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
       }
}

// MARK: Data Source
extension CampaignsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CampaignCell.identifier, for: indexPath)
                as? CampaignCell else {
            fatalError()
        }
        cell.configure(with: self.items[indexPath.row])
        return cell
    }

}

// MARK: Debug
extension CampaignsCollectionViewController {
    #if DEBUG
    func debugView() {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.yellow.cgColor
    }
    #endif
}
