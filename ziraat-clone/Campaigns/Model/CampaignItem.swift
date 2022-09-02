//
//  CampaignItem.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/29/22.
//

import Foundation

struct CampaignItem: Identifiable {
    let id: String
    let image: String
    let link: String?
    let read: Bool
        
    init(id: String, image: String, link: String?, read: Bool = false) {
        self.id = id
        self.image = image
        self.link = link
        self.read = read
    }

}

extension CampaignItem: Equatable {
    static func == (lhs: CampaignItem, rhs: CampaignItem) -> Bool {
        return lhs.id == rhs.id
    }
}
