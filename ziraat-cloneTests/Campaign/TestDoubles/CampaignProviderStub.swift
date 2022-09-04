//
//  CampaignProviderStub.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation
@testable import ziraat_clone

struct CampaignProviderStub: CampaignProvider {
    let stubs: [CampaignItem]

    init(_ stubs: [CampaignItem]) {
        self.stubs = stubs
    }
    
    func campaigns(completion: @escaping ([CampaignItem]) -> Void) {
        completion(stubs)
    }
}
