//
//  CampaignCollectionViewModelTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/3/22.
//

import XCTest
@testable import ziraat_clone

class CampaignCollectionViewModelTests: XCTestCase {
    func makeStore(startsWith items: [CampaignItem] = []) throws -> CampaignCoreDataStore {
        let container = PersistentContainerFactory.create(of: .inMemory)
        let store = CampaignCoreDataStore(container: container)
        try items.forEach { item in
            try store.add(item)
        }
        return store
    }

    // MARK: markAsRead
    func test_markAsReadIfNeeded_doesntProceedIfAlreadyRead() throws {
        let storeSpy = CampaignStoreSpy()
        let viewModel = CampaignCollectionViewModel(provider: DummyCampaignProvider(), store: storeSpy)
        let item = CampaignViewModel(id: "1", image: "image", link: nil, read: true)
        viewModel.campaignViewModels = [item]

        var campaignsChanged = false
        viewModel.onCampaignsChanged = {_ in
            campaignsChanged = true
        }
        
        viewModel.markAsReadIfNeeded(item)
        XCTAssertEqual(storeSpy.idsMarkedAsRead.count, 0)
        XCTAssertEqual(campaignsChanged, false)
    }
    
    func test_markAsReadIfNeeded_persistsChangeAndUpdatesViewModels() throws {
        // Arrange
        let storeSpy = CampaignStoreSpy()
        let viewModel = CampaignCollectionViewModel(provider: DummyCampaignProvider(), store: storeSpy)
        let item = CampaignViewModel(id: "1", image: "image", link: nil, read: false)
        viewModel.campaignViewModels = [item]
        let oldItems = viewModel.campaignViewModels

        var campaignsChanged = false
        viewModel.onCampaignsChanged = {_ in
            campaignsChanged = true
        }
        
        // Act
        viewModel.markAsReadIfNeeded(item)
        
        // Assert
        XCTAssertEqual(storeSpy.idsMarkedAsRead.count, 1)
        XCTAssertEqual(campaignsChanged, true)
        XCTAssertNotEqual(oldItems.map(\.read), viewModel.campaignViewModels.map(\.read))
    }
    
    
}

// MARK: load()
extension CampaignCollectionViewModelTests {
    func test_load_AssignsToViewModels() throws {
        // Arrange
        let storeSpy = try makeStore()
        let stubs: [CampaignItem] = [
            .init(id: "1", image: "image", link: nil, read: false)
        ]
        let providerStub = CampaignProviderStub(stubs)
        let sut = CampaignCollectionViewModel(provider: providerStub,
                                                    store: storeSpy)
        var campaignsChanged = false
        sut.onCampaignsChanged = {_ in
            campaignsChanged = true
        }
        
        // Act
        sut.load()
        
        // Assert
        XCTAssertEqual(campaignsChanged, true)
        XCTAssertEqual(sut.campaignViewModels.map(\.id), stubs.map(\.id))
    }
}

struct DummyCampaignProvider: CampaignProvider {
    func campaigns(completion: @escaping ([CampaignItem]) -> Void) {
        completion([])
    }
}

struct CampaignProviderStub: CampaignProvider {
    let stubs: [CampaignItem]

    init(_ stubs: [CampaignItem]) {
        self.stubs = stubs
    }
    
    func campaigns(completion: @escaping ([CampaignItem]) -> Void) {
        completion(stubs)
    }
}
