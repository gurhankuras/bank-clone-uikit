//
//  CampaignViewModelMapper.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

/*
class CampaignViewModelMapper: CampaignViewModelProvider {
    typealias ViewModelSelectionHandler = (CampaignViewModel) -> Void
    
    let campaignProvider: CampaignProvider
    let selectHandler: ViewModelSelectionHandler
    
    init(campaignProvider: CampaignProvider, selectHandler: @escaping ViewModelSelectionHandler) {
        self.campaignProvider = campaignProvider
        self.selectHandler = selectHandler
    }
    
    func campaignViewModels(completion: @escaping ([CampaignViewModel]) -> Void) {
        return campaignProvider.campaigns(completion: {
            let viewModels: [CampaignViewModel] = $0.map({ item in
                return .init(item: item, onSelect: { [weak self] vm in
                    self?.selectHandler(vm)
                })
            })
            completion(viewModels)
        })
    }
}
*/
