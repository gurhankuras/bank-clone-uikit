//
//  CampaignViewModelProvider.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

protocol CampaignViewModelProvider {
    func campaignViewModels(completion: @escaping ([CampaignViewModel]) -> Void)
}
