//
//  CampaignViewModel.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

struct CampaignViewModel: Identifiable, Equatable {
    let id: String
    let image: String
    let link: String?
    let onSelect: ((CampaignViewModel) -> Void)?
    var didSelect: ((CampaignViewModel) -> Void)?
    var read: Bool
    
    init(id: String, image: String, link: String?, read: Bool) {
        self.id = id
        self.image = image
        self.link = link
        self.onSelect = nil
        self.read = read
    }
    
    static func == (lhs: CampaignViewModel, rhs: CampaignViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hasLink: Bool {
        link != nil
    }
    
    mutating func markAsRead() {
        read = true
    }
    
    func select() {
        didSelect?(self)
        self.onSelect?(self)
    }
}
