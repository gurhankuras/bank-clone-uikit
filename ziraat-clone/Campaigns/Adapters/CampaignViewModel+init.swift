//
//  CampaignViewModel+init.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

extension CampaignViewModel {
    init(item: CampaignItem) {
        self.link = item.link
        self.image = item.image
        self.id = item.id
        self.read = item.read
        self.onSelect = nil
    }
}
