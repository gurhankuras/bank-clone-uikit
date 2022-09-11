//
//  CampaignProvider.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

protocol CampaignProvider {
    func campaigns(completion: @escaping ([CampaignItem]) -> Void)
}
