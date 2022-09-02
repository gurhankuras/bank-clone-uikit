//
//  CampaignCacheRemoteSynchronizerTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/2/22.
//

import XCTest
@testable import ziraat_clone

// `[CampaignCacheRemoteSynchronizer]`
class CampaignCacheRemoteSynchronizerTests: XCTestCase {
    struct AnyError: Error {}
    typealias Response = Result<CampaignUpdates, Error>
    
    func test_shouldSaveNewCampaignsToStore_whenResponseIsSuccess() throws {
        let store = CampaignStoreStub(items: [:])
        let responses: [Response] = [
            .success(.init(active: [CampaignItem(id: "1", image: "gurhan", link: nil)],
                           deleted: [], version: "1"))
        ]
        let remote = CampaignTrackerStub(stubResults: responses)
        let sut = CampaignCacheRemoteSynchronizer(store: store, remote: remote)
        
        sut.campaigns { _ in }
        
        let count = try store.getAll().count
        XCTAssertEqual(count, 1)
    }
    
    func test_shouldNotSaveAnyCampaignsToStore_whenResponseIsFailure() throws {
        let store = CampaignStoreStub(items: [:])
        let responses: [Response] = [
            .failure(AnyError())
        ]
        let remote = CampaignTrackerStub(stubResults: responses)
        let sut = CampaignCacheRemoteSynchronizer(store: store, remote: remote)
        
        sut.campaigns { _ in }
        
        let count = try store.getAll().count
        print(count)
        XCTAssertEqual(count, 0)
    }
    
    func test_shouldReturnExistingCampaignsFromCache_whenResponseIsFailure() throws {
        let campaignStub = try XCTUnwrap(stubs.first)
        let store = CampaignStoreStub(items: ["1": campaignStub])
        let responses: [Response] = [
            .failure(AnyError())
        ]
        let remote = CampaignTrackerStub(stubResults: responses)
        let sut = CampaignCacheRemoteSynchronizer(store: store, remote: remote)
        
        var fetchedCampaigns: [CampaignItem]?
        sut.campaigns { fetchedCampaigns = $0 }
        
        XCTAssertNotNil(fetchedCampaigns)
        XCTAssertEqual(fetchedCampaigns?.count, 1)
        XCTAssertEqual(fetchedCampaigns, [campaignStub])
    }
    
    func test_shouldPassParametersCorrectlyToStore_whenResponseIsSuccess() throws {
        let store = CampaignStoreStub(items: [:])
        
        let idsToDelete = ["2", "3"]
        let activeItems = [stubs.first!]
        
        let responses: [Response] = [
            .success(.init(active: activeItems, deleted: idsToDelete, version: "1"))
        ]
        let remote = CampaignTrackerStub(stubResults: responses)
        let sut = CampaignCacheRemoteSynchronizer(store: store, remote: remote)
        
        sut.campaigns { _ in }

        XCTAssertEqual(store.deleteIds.count, 1)
        XCTAssertEqual(store.deleteIds.first, idsToDelete)
        XCTAssertEqual(store.newItemsList.count, 1)
        XCTAssertEqual(store.newItemsList.first, activeItems)
    }
}

extension CampaignCacheRemoteSynchronizerTests {
    var stubs: [CampaignItem] {
        return [
            CampaignItem(id: "1", image: "kampanya1", link: nil, read: true),
            CampaignItem(id: "2", image: "kampanya2", link: "link", read: false),
            CampaignItem(id: "3", image: "kampanya3", link: nil, read: false),
            CampaignItem(id: "4", image: "kampanya4", link: nil, read: false),
            CampaignItem(id: "5", image: "kampanya5", link: nil, read: false)
        ]
    }
}

class CampaignStoreStub: CampaignStore {
    private(set) var newItemsList: [[CampaignItem]] = []
    private(set) var deleteIds: [[CampaignItem.ID]] = []
    
    init(items: [CampaignItem.ID: CampaignItem] = [:]) {
        self.items = items
    }
    
    var items: [CampaignItem.ID: CampaignItem]
    func update(with newItems: [CampaignItem], deleting ids: [CampaignItem.ID]) throws {
        audit(with: newItems, deleting: ids)
        for item in newItems {
            items[item.id] = item
        }
        
        ids.forEach { id in
            items.removeValue(forKey: id)
        }
    }
    
    private func audit(with newItems: [CampaignItem], deleting ids: [CampaignItem.ID]) {
        newItemsList.append(newItems)
        deleteIds.append(ids)
    }
    
    func getAll() throws -> [CampaignItem] {
        return items.values.map { $0 }
    }
}

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

