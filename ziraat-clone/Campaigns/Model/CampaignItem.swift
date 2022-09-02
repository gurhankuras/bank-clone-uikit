//
//  CampaignItem.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/29/22.
//

import Foundation

struct CampaignItem: Identifiable {
    var id: String
    var image: String
    var link: String?
    var read: Bool
        
    init(id: String, image: String, link: String?, read: Bool = false) {
        self.id = id
        self.image = image
        self.link = link
        self.read = read
    }

}

extension CampaignItem: Equatable {
    
}
