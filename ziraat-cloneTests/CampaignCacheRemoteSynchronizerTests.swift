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
    
    func makeStore(startsWith items: [CampaignItem] = []) throws -> CampaignCoreDataStore {
        let container = PersistentContainerFactory.create(of: .inMemory)
        let store = CampaignCoreDataStore(container: container)
        try items.forEach { item in
            try store.add(item)
        }
        return store
    }
    
    func test_shouldSaveNewCampaignsToStore_whenResponseIsSuccess() throws {
        let store = try makeStore()
        let responses: [Response] = [
            .success(.init(active: [CampaignItem(id: "1", image: "gurhan", link: nil)],
                           deleted: [], version: "1"))
        ]
        let remote = CampaignTrackerStub(stubResults: responses)
        let sut = CampaignCacheRemoteSynchronizer(store: store, remote: remote)
        
        sut.campaigns { _ in }
    
        XCTAssertEqual(try store.getAll().count, 1)
    }
    
    func test_shouldReturnMergedItems_whenResponseIsSuccess() throws {
        
        let itemInStore = CampaignItem(id: "1", image: "gurhan", link: nil, read: true)
        let store = try makeStore(startsWith: [itemInStore])
        
        var itemInResponse = itemInStore
        itemInResponse.read = false
        let responses: [Response] = [
            .success(.init(active: [itemInResponse],
                           deleted: [], version: "1"))
        ]
        let remote = CampaignTrackerStub(stubResults: responses)
        let sut = CampaignCacheRemoteSynchronizer(store: store, remote: remote)
        
        var actives: [CampaignItem]?
        sut.campaigns {
            actives = $0
        }
        
        XCTAssertEqual(actives?.first, itemInStore)
    }
    
    func test_shouldNotSaveAnyCampaignsToStore_whenResponseIsFailure() throws {
        let store = try makeStore()
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
        let store = try makeStore(startsWith: [campaignStub])
        
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
        let store = CampaignStoreSpy()
        
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

