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
    
    func makeSut(startsWith items: [CampaignItem] = []) throws -> CampaignCoreDataStore {
        let container = PersistentContainerFactory.create(of: .inMemory)
        let store = CampaignCoreDataStore(container: container)
        try items.forEach { item in
            try store.add(item)
        }
        return store
    }
    
    func test_AddsAnItem() throws {
        let sut = try makeSut()
        let item = stubs.first!
        try sut.add(item)
        
        XCTAssertEqual(try sut.getAll().count, 1)
    }
    
    func test_updatesExistingItem_whenNewItemWithSameIdAdded() throws {

        // Arrange
        let sut = try makeSut()
        let firstAddedItem = stubs.first!
        var updatedItem = stubs.first!
        updatedItem.image = "kampanya10"
        
        // Act
        try sut.add(firstAddedItem)
        
        try sut.update(with: [updatedItem], deleting: [])
        
        var allItems = try sut.getAll()
        let fetchedItem = try XCTUnwrap(allItems.first)
        
        // Assert
        XCTAssertEqual(allItems.count, 1)
        XCTAssertNotEqual(fetchedItem, firstAddedItem)
        XCTAssertEqual(fetchedItem, updatedItem)
    }
    
    func test_addsItem_whenItemWithDifferentIdAdded() throws {
        let sut = try makeSut()
        let newItem = stubs.first!
        try sut.update(with: [newItem], deleting: [])
        
        let items = try sut.getAll()
        XCTAssertEqual(items.count, 1)
    }
    
    func test_updatesExistingItemAndInsertsNewOne_whenNewItemWithSameIdArndNewOneAdded() throws {
        let sut = try makeSut()
        let firstItem = try XCTUnwrap(stubs.first)
        var updatedItem = firstItem
        updatedItem.image = "kampanya9"
        let newItem = try XCTUnwrap(stubs[1])

        try sut.update(with: [updatedItem, newItem], deleting: [])
        try sut.update(with: [updatedItem], deleting: [newItem.id])
        
        let items = try sut.getAll()
        XCTAssertEqual(items.count, 1)
    }
    
    func test_throwsError_whenUpdatedItemsIsEmpty() throws {
        let sut = try makeSut()
        try sut.add(try XCTUnwrap(stubs.first))
        var new = try XCTUnwrap(stubs.first!)
        new.read = false
        try sut.update(with: [new], deleting: [])
        let items = try sut.getAll()
    }

    func compare(lhs: CampaignItem, rhs: CampaignItem) -> Bool { return lhs.id < rhs.id }

    
    func test_mergingJustAddsItemsInParameter_whenStoreIsEmpty() throws {
        let sut = try makeSut()
        XCTAssertEqual(try sut.getAll().count, 0)
        let items = stubs.prefix(through: 1).map({ $0 }).sorted(by: compare)
        try sut.mergeItems(with: items)
        XCTAssertEqual(try sut.getAll().count, items.count)
        XCTAssertEqual(try sut.getAll().sorted(by: compare), items)
    }
    
    func test_merges_whenStoreIsNotEmpty() throws {
        let sut = try makeSut()
        XCTAssertEqual(try sut.getAll().count, 0)
        let item = try XCTUnwrap(stubs.first)
        try sut.add(item)
        let changedTo = CampaignItem(id: "1", image: "kampanya5", link: nil, read: false)
        try sut.mergeItems(with: [changedTo])
        XCTAssertEqual(try sut.getAll().count, 1)
        XCTAssertEqual(try sut.getAll().first?.read, item.read)
    }
    
    // Server doesnt keep whether we viewed campaign or not. So when we request data from
    // server because of merge policy without any intervention local data replaced by
    // later arrived data (server-origin) but we dont want this due to data loss (view property is gone)

    func test_readStateShouldStaySameAsBefore_whenNewDataArrived() throws {
        func compare(lhs: CampaignItem, rhs: CampaignItem) -> Bool { return lhs.id < rhs.id }
        let sut = try makeSut()
        let items = stubs
        try items.forEach { try sut.add($0) }
        
        let laterArrivedItems = items
            .map({ CampaignItem(id: $0.id, image: $0.image, link: nil, read: !$0.read) })
        try sut.mergeItems(with: laterArrivedItems)
        
        XCTAssertEqual(try sut.getAll().count, items.count)
        XCTAssertEqual(try sut.getAll().sorted(by: compare).map(\.read), items.map(\.read))
    }

}

extension CampaignCoreDataStoreTests {
    func test_markAsRead_setsReadToTrue() throws {
        let sut = try makeSut(startsWith: stubs)
        let willMarkedItem = CampaignItem(id: "1", image: "image", link: nil, read: false)
        XCTAssertEqual(willMarkedItem.read, false)
        try sut.markAsRead(willMarkedItem.id)
        let fetchedItem = try sut.getAll().first
        XCTAssertEqual(fetchedItem?.id, willMarkedItem.id)
        XCTAssertEqual(fetchedItem?.read, true)
    }
    
    func test_markAsRead_throwsErrorWhenNotFound() throws {
        let sut = try makeSut()
        let errorMessage = "A CampaignStoreError.campaignNotFound Error should have been thrown but no Error was thrown"
        XCTAssertThrowsError(try sut.markAsRead("1"), errorMessage) { error in
            XCTAssertTrue(error is CampaignCoreDataStore.CampaignStoreError)
            let error = error as! CampaignCoreDataStore.CampaignStoreError
            XCTAssertTrue(error == .campaignNotFound)
        }
    }
}
