//
//  CampaignCacheRemoteSynchronizer.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/2/22.
//

import Foundation

class CampaignCacheRemoteSynchronizer: CampaignProvider {
    let store: CampaignStore
    let remote: CampaignTracker
    
    init(store: CampaignStore, remote: CampaignTracker) {
        self.store = store
        self.remote = remote
    }
    func campaigns(completion: @escaping ([CampaignItem]) -> Void) {
        remote.campaigns { [weak self] result in
            switch result {
            case .failure(let error):
                guard let cachedItems = try? self?.store.getAll() else {
                    completion([])
                    return
                }
                completion(cachedItems)
            case .success(let updates):
                do {
                    try self?.store.update(with: updates.active, deleting: updates.deleted)
                    let composed = try self?.store.getAll()
                    completion(composed ?? [])
                } catch {
                    print(error)
                    completion([])
                }
                // dehydrate with local storage
                
            }
        }
    }
}
