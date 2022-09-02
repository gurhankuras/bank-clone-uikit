//
//  CampaignStore.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/2/22.
//

import Foundation
import CoreData


enum CampaignEntityMapper {
    static func map(_ entity: CampaignEntity) -> CampaignItem? {
        guard let id = entity.id,
              let image = entity.image
        else { return nil }
        return CampaignItem(id: id, image: image, link: entity.link, read: entity.read)
    }
}

protocol CampaignStore {
    func update(with newItems: [CampaignItem], deleting ids: [CampaignItem.ID]) throws
    func getAll() throws -> [CampaignItem]
}

class CampaignCoreDataStore: CampaignStore {
    func update(with newItems: [CampaignItem], deleting ids: [CampaignItem.ID]) throws {
        let deleteRequest = batchDeleteRequest(with: ids)
        try insertBatch(with: newItems)
        try context.execute(deleteRequest)
        try saveIfNeeded()
    }
    
    private func batchDeleteRequest(with idsToDelete: [CampaignItem.ID]) -> NSPersistentStoreRequest {
        let predicate = NSPredicate(format: "id IN %@", idsToDelete)
        let request: NSFetchRequest<NSFetchRequestResult> = CampaignEntity.fetchRequest()
        request.predicate = predicate
        let batchRequest = NSBatchDeleteRequest(fetchRequest: request)
        return batchRequest
    }
    
    private func insertBatch(with items: [CampaignItem]) throws {
        if items.isEmpty {
            return
        }
        let dicts = items.map { item in
            return [
                "id": item.id,
                "link": item.link as Any,
                "image": item.image,
                "read": item.read
            ]
        }
        let insertRequest = NSBatchInsertRequest(entity: CampaignEntity.entity(), objects: dicts)
        try context.execute(insertRequest)
    }
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.context = container.newBackgroundContext()
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext!
    
    func getAll() throws -> [CampaignItem] {
        let request = CampaignEntity.fetchRequest()
        let campaigns = try context.fetch(request)
        return campaigns.compactMap({ CampaignEntityMapper.map($0) })
    }
    
    
    func add(_ campaign: CampaignItem) throws {
        guard let entityDesc  = NSEntityDescription.entity(forEntityName: "CampaignEntity", in: self.context) else {
            return
        }
        let campaignEntity = CampaignEntity(entity: entityDesc, insertInto: self.context)
        campaignEntity.read = false
        campaignEntity.id = campaign.id
        campaignEntity.link = campaign.link
        campaignEntity.image = campaign.image
        try self.saveIfNeeded()
    }
     
    
    @discardableResult
    func saveIfNeeded() throws -> Bool {
        guard context.hasChanges else { return false }
        try context.save()
        return true
    }
}
