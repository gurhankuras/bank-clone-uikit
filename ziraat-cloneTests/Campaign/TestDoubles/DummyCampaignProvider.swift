//
//  DummyCampaignProvider.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation
@testable import ziraat_clone

struct DummyCampaignProvider: CampaignProvider {
    func campaigns(completion: @escaping ([CampaignItem]) -> Void) {
        completion([])
    }
}
