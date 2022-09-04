//
//  CampaignStoreSpy.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/4/22.
//

import Foundation
@testable import ziraat_clone

class CampaignStoreSpy: CampaignStore {
    func markAsRead(_ id: CampaignItem.ID) throws {
        idsMarkedAsRead.append(id)
    }
    
    private(set) var newItemsList: [[CampaignItem]] = []
    private(set) var deleteIds: [[CampaignItem.ID]] = []
    private(set) var idsMarkedAsRead: [CampaignItem.ID] = []
    
    func update(with newItems: [CampaignItem], deleting ids: [CampaignItem.ID]) throws {
        newItemsList.append(newItems)
        deleteIds.append(ids)
    }
    
    func getAll() throws -> [CampaignItem] {
        return []
    }
}
