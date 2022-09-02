//
//  CampaignAPI.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

class CampaignAPI: CampaignProvider {
    func campaigns(completion: @escaping ([CampaignItem]) -> Void) {
        completion(items)
    }
    
    var items: [CampaignItem] {
        return [
            CampaignItem(id: "1",
                         image: "kampanya2",
                         link: "https://www.ziraatbank.com.tr/tr/bankamiz/basin-odasi/ziraatten-yenilikler/karekod-prim-tahsilati"),
            CampaignItem(id: "2",
                         image: "kampanya",
                         link: nil),
            CampaignItem(id: "3",
                         image: "kampanya3",
                         link: nil)
        ]
    }
}
