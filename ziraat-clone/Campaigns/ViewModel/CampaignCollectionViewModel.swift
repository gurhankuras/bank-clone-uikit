//
//  CampaignsViewModel.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

class CampaignCollectionViewModel {
    let provider: CampaignProvider
    let store: CampaignStore
    var campaignViewModels: [CampaignViewModel] = [] {
        didSet {
            onCampaignsChanged?(campaignViewModels)
        }
    }
    var onCampaignsChanged: (([CampaignViewModel]) -> Void)?
    
    init(provider: CampaignProvider, store: CampaignStore) {
        self.provider = provider
        self.store = store
    }
    
    func load() {
        provider.campaigns(completion: { [weak self] items in
            self?.campaignViewModels = items.map({ .init(item: $0)})
        })
    }
    
    func markAsReadIfNeeded(_ item: CampaignViewModel) {
        guard !item.read else { return }
        let id = item.id
        guard let _ = try? store.markAsRead(id) else {
            fatalError("Marking as Viewed Failed due to store!")
        }
        
        if let index = self.campaignViewModels.firstIndex(where: { $0.id == id }) {
            campaignViewModels[index].read = true
        }
    }
    
    // private func update

}
