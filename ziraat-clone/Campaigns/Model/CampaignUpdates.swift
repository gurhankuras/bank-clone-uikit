//
//  CampaignUpdates.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/2/22.
//

import Foundation

struct CampaignUpdates {
    let active: [CampaignItem]
    let deleted: [CampaignItem.ID]
    let version: String
}
