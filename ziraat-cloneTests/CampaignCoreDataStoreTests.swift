//
//  CampaignCoreDataStoreTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/2/22.
//

import XCTest
@testable import ziraat_clone
import CoreData




class CampaignCoreDataStoreTests: XCTestCase {
    var stubs: [CampaignItem] {
        return [
            CampaignItem(id: "1", image: "kampanya1", link: nil, read: true),
            CampaignItem(id: "2", image: "kampanya2", link: "link", read: false),
            CampaignItem(id: "3", image: "kampanya3", link: nil, read: false),
            CampaignItem(id: "4", image: "kampanya4", link: nil, read: false),
            CampaignItem(id: "5", image: "kampanya5", link: nil, read: false)
        ]
    }
    
    func makeInMemory() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "Data")
        let desc = NSPersistentStoreDescription()
        desc.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [desc]
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }
    
    func test_AddsAnItem() throws {
        let container = makeInMemory()
        let store = CampaignCoreDataStore(container: container)
        let item = stubs.first!
        try store.add(item)
    }
    
    func test_updatesExistingItem_whenNewItemWithSameIdAdded() throws {

        // Arrange
        let container = makeInMemory()
        let store = CampaignCoreDataStore(container: container)
        let firstAddedItem = stubs.first!
        var updatedItem = stubs.first!
        updatedItem.image = "kampanya10"
        
        // Act
        try store.add(firstAddedItem)
        try store.update(with: [updatedItem], deleting: [])

        var allItems = try store.getAll()
        let fetchedItem = try XCTUnwrap(allItems.first)
        
        // Assert
        XCTAssertEqual(allItems.count, 1)
        XCTAssertNotEqual(fetchedItem, firstAddedItem)
        XCTAssertEqual(fetchedItem, updatedItem)
    }
    
    func test_addsItem_whenItemWithDifferentIdAdded() throws {
        let container = makeInMemory()
        let store = CampaignCoreDataStore(container: container)
        let newItem = stubs.first!
        try store.update(with: [newItem], deleting: [])
        
        let items = try store.getAll()
        XCTAssertEqual(items.count, 1)
    }
    
    func test_updatesExistingItemAndInsertsNewOne_whenNewItemWithSameIdArndNewOneAdded() throws {
        let container = makeInMemory()
        let store = CampaignCoreDataStore(container: container)
        let firstItem = try XCTUnwrap(stubs.first)
        var updatedItem = firstItem
        updatedItem.image = "kampanya9"
        let newItem = try XCTUnwrap(stubs[1])

        try store.update(with: [updatedItem, newItem], deleting: [])
        try store.update(with: [updatedItem], deleting: [newItem.id])
        
        let items = try store.getAll()
        XCTAssertEqual(items.count, 1)
    }
    
    func test_throwsError_whenUpdatedItemsIsEmpty() throws {
        let container = makeInMemory()
        let store = CampaignCoreDataStore(container: container)
        try store.update(with: [], deleting: [])
    }

}
