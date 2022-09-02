//
//  CampaignAPI.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation

protocol CampaignVersionProviding {
    var version: String? { get set }
}

class CampaignUserDefaultsVersionProvider: CampaignVersionProviding {
    private let key = "campaign_version"
    
    var version: String? {
        get {
            UserDefaults.standard.string(forKey: key)
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: key)
                return
            }
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

class CampaignAPI: CampaignTracker {
    private(set) var versionProvider: CampaignVersionProviding

    init(versionProvider: CampaignVersionProviding) {
        self.versionProvider = versionProvider
    }
    
    func campaigns(completion: @escaping (Result<CampaignUpdates, Error>) -> Void) {
        versionProvider.version = updates.version
        completion(.failure(URLError.init(.cancelled)))
        // completion(.success(updates))
    }
    
    var updates: CampaignUpdates {
        return
        CampaignUpdates(active: [
           /*
            CampaignItem(id: "1",
                         image: "kampanya2",
                         link: "https://www.ziraatbank.com.tr/tr/bankamiz/basin-odasi/ziraatten-yenilikler/karekod-prim-tahsilati"),
            */
            CampaignItem(id: "2",
                         image: "kampanya",
                         link: nil),
             
            CampaignItem(id: "3",
                         image: "kampanya3",
                         link: nil)
        ],
        deleted: ["1"],
        version: "")
        
    }
}
