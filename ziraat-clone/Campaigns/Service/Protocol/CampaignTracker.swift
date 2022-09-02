//
//  CampaignTracker.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/2/22.
//

import Foundation

protocol CampaignTracker {
    func campaigns(completion: @escaping (Result<CampaignUpdates, Error>) -> Void)
}
