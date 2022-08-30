//
//  CampaignItem.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/29/22.
//

import Foundation

struct CampaignItem: Identifiable, Equatable {
    static func == (lhs: CampaignItem, rhs: CampaignItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let image: String
    let link: String?
    let select: ((CampaignItem) -> Void)?
}
