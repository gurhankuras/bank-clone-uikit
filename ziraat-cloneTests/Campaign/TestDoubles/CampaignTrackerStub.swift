//
//  CampaignTrackerStub.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation
@testable import ziraat_clone

class CampaignTrackerStub: CampaignTracker {
    var stubResults: [Result<CampaignUpdates, Error>]
    
    init(stubResults: [Result<CampaignUpdates, Error>] = []) {
        self.stubResults = stubResults
    }
    func campaigns(completion: @escaping (Result<CampaignUpdates, Error>) -> Void) {
        guard !stubResults.isEmpty else {
            fatalError("There is no stubbed result left!")
        }
        let result = stubResults.remove(at: 0)
        completion(result)
    }
}
