//
//  CampaignsViewModel.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

class CampaignCollectionViewModel {
    var campaignViewModels: [CampaignViewModel] = [] {
        didSet {
            onCampaignsChanged?(campaignViewModels)
        }
    }
    
    var onCampaignsChanged: (([CampaignViewModel]) -> Void)?
    let provider: CampaignProvider
    
    init(provider: CampaignProvider) {
        self.provider = provider
    }
    
    func load() {
        provider.campaigns(completion: { [weak self] items in
            self?.campaignViewModels = items.map({ .init(item: $0)})
        })
    }
    
    func markAsRead(id: CampaignViewModel.ID) {
        let filtered: [CampaignViewModel] = self.campaignViewModels.map({ item in
            if id == item.id {
                var copy = item
                copy.read = true
                return copy
            }
            return item
        })
        self.campaignViewModels = filtered
    }
}
