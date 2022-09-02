//
//  CampaignsResponse.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/2/22.
//

import Foundation

struct CampaignsResponse {
    let campaigns: [CampaignsResponse.Campaign]
    let deleted: CampaignsResponse.Deleted
    let versionToken: String
}

extension CampaignsResponse {
    // MARK: - Campaign
    struct Campaign {
        let id, image, link: String
        let read: Bool
    }

    // MARK: - Deleted
    struct Deleted {
        let campaigns: [String]
    }
}
