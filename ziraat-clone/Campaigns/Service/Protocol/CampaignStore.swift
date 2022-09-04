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
    func markAsRead(_ id: CampaignItem.ID) throws
}

class CampaignCoreDataStore: CampaignStore {
    public enum CampaignStoreError: Error {
        case campaignNotFound
    }
    func markAsRead(_ id: CampaignItem.ID) throws {
        try context.performAndWait {
            let request = CampaignEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            let campaigns = try context.fetch(request)
            guard let first = campaigns.first else {
                throw CampaignStoreError.campaignNotFound
            }
            dump(first)
            first.read = true
            try self.saveIfNeeded()
        }
    }
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext!
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.context = container.newBackgroundContext()
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func update(with newItems: [CampaignItem], deleting ids: [CampaignItem.ID]) throws {
        try context.performAndWait {
            let deleteRequest = batchDeleteRequest(with: ids)
            try mergeItems(with: newItems)
            try context.execute(deleteRequest)
        }
    }
    
    private func batchDeleteRequest(with idsToDelete: [CampaignItem.ID]) -> NSPersistentStoreRequest {
        let predicate = NSPredicate(format: "id IN %@", idsToDelete)
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CampaignEntity")
        request.predicate = predicate
        let batchRequest = NSBatchDeleteRequest(fetchRequest: request)
        return batchRequest
    }
    
    func mergeItems(with items: [CampaignItem]) throws {
        if items.isEmpty {
            return
        }
        
        try context.performAndWait {
            let fetchRequest = CampaignEntity.fetchRequest()
            let campaigns = try context.fetch(fetchRequest)
            
            var mm = [String: CampaignEntity]()
            campaigns.forEach({
                guard let id = $0.id else { return }
                mm[id] = $0
            })
            
            let dicts = items.map { item in
                return [
                    "id": item.id,
                    "link": item.link as Any,
                    "image": item.image,
                    "read": mm[item.id]?.read ?? item.read
                ]
            }
            
            let insertRequest = NSBatchInsertRequest(entity: CampaignEntity.entity(), objects: dicts)
            try context.execute(insertRequest)
        }
        
        
        
        /*
        var idMap: Dictionary<String, [String: Any]> = [:]
        dicts.forEach { map in
            guard let id = map["id"] as? String else {
                return
            }
            idMap[id] = map
        }
        
        try context.performAndWait {
            let fetchRequest = CampaignEntity.fetchRequest()
            // fetchRequest.propertiesToFetch = ["read", "id"]
            let campaigns = try context.fetch(fetchRequest)
            for campaign in campaigns {
                guard let id = campaign.id,
                      var item = idMap[id] else { continue }
                item["read"] = campaign.read
                idMap[id] = item
                print("\(campaign.id): \(campaign.read)")
            }
            
            let insertRequest = NSBatchInsertRequest(entity: CampaignEntity.entity(), objects: idMap.values.map({ $0 }))
            try context.execute(insertRequest)
        }
         */
    }
    
  
    
    func getAll() throws -> [CampaignItem] {
        return try context.performAndWait {
            let request = CampaignEntity.fetchRequest()
            let campaigns = try context.fetch(request)
            return campaigns.compactMap({ CampaignEntityMapper.map($0) })
        }
    }
    
    func add(_ campaign: CampaignItem) throws {
        guard let entityDesc  = NSEntityDescription.entity(forEntityName: "CampaignEntity", in: self.context) else {
            return
        }
        let campaignEntity = CampaignEntity(entity: entityDesc, insertInto: self.context)
        campaignEntity.read = campaign.read
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
