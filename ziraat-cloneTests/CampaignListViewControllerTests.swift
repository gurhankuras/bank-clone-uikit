//
//  CampaignListViewControllerTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/3/22.
//

import XCTest
@testable import ziraat_clone

class CampaignListViewControllerTests: XCTestCase {
    
    var stub: CampaignViewModel {
        .init(id: "1", image: "image", link: nil, read: false)
    }
    func makeViewModel() -> (CampaignCollectionViewModel, CampaignStoreSpy) {
        let dummyProvider = DummyCampaignProvider()
        let storeSpy = CampaignStoreSpy()
        let viewModel = CampaignCollectionViewModel(provider: dummyProvider, store: storeSpy)
        viewModel.campaignViewModels = [stub]
        return (viewModel, storeSpy)
    }
    
    func test_viewDidLoad_registersViewModelCallbacks() throws {
        let (vm, _) = makeViewModel()
        let sut = CampaignListViewController(viewModel: vm)
        _ = sut.view
        XCTAssertNotNil(vm.onCampaignsChanged)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CampaignListViewControllerTests {
    func test_collectionView_selects() throws {
        let (vm, storeSpy) = makeViewModel()
        let sut = CampaignListViewController(viewModel: vm)
        _ = sut.view

        var selectedCampaign: CampaignViewModel?
        sut.onCampaignSelected = { selectedCampaign = $0 }
        sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(selectedCampaign)
        XCTAssertEqual(selectedCampaign?.id, storeSpy.idsMarkedAsRead.first)
        XCTAssertEqual(storeSpy.idsMarkedAsRead.count, 1)
        XCTAssertEqual(storeSpy.idsMarkedAsRead.first, stub.id)
    }
}

// MARK: UICollectionViewDataSource
extension CampaignListViewControllerTests {
    func test_collectionView_registersCellAndReturnsIt() throws {
        let (vm, _) = makeViewModel()
        let sut = CampaignListViewController(viewModel: vm)
        _ = sut.view
        
        let cell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is CampaignListViewController.CellType)
        let campaignCell = cell as! CampaignListViewController.CellType
        XCTAssertEqual(campaignCell.item?.id, stub.id)
    }
    
    func test_collectionView_rowCountShouldBeEqualToViewModelCount() throws {
        let (vm, _) = makeViewModel()
        let sut = CampaignListViewController(viewModel: vm)
        _ = sut.view
        
        let rowCount = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        
        XCTAssertEqual(vm.campaignViewModels.count, rowCount)
    }
}
