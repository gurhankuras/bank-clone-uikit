//
//  CampaignsCollectionView.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/29/22.
//

import Foundation
import UIKit

class CampaignListViewController: UIViewController {
    typealias CellType = CampaignListCell
    
    var collectionView: UICollectionView!
    var onCampaignSelected: ((CampaignViewModel) -> Void)?

    var viewModel: CampaignCollectionViewModel!
    
    convenience init(viewModel: CampaignCollectionViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        viewModel.onCampaignsChanged = { [weak self] items in
            print(items)
            self?.collectionView.reloadData()
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CellType.self,
                                forCellWithReuseIdentifier: CellType.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Layout Delegate
extension CampaignListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.campaignViewModels[indexPath.row]
        self.onCampaignSelected?(item)
        viewModel.markAsReadIfNeeded(item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
       }
}

// MARK: Data Source
extension CampaignListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.campaignViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CampaignListCell.identifier, for: indexPath)
                as? CellType else {
            fatalError()
        }
        cell.configure(with: viewModel.campaignViewModels[indexPath.row])
        return cell
    }

}

// MARK: Debug
extension CampaignListViewController {
    #if DEBUG
    func debugView() {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.yellow.cgColor
    }
    #endif
}
