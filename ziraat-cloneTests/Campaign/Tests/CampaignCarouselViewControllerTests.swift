//
//  CampaignCarouselViewControllerTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 9/3/22.
//

import XCTest
@testable import ziraat_clone

class CampaignCarouselViewControllerTests: XCTestCase {
    
    func test_CampaignCarouselViewController_startsWithInitialState() throws {
        let items = stubs
        let startItem = items[1]
        let sut = CampaignCarouselViewController(items: items, startItem: startItem, durationPerSlide: 0)
        
        XCTAssertEqual(sut.startItem, startItem)
        XCTAssertEqual(items, sut.items)
        XCTAssertEqual(sut.pageIndex, 0)
    }
    
    func test_viewDidLoad_setsPageIndexAndStartsSlide_basedOnStartItem() throws {
        let items = stubs
        let index = 2
        let startItem = items[index]
        let sut = CampaignCarouselViewController(items: items, startItem: startItem, durationPerSlide: 0)
        _ = sut.view
        
        let slide = currentSlide(in: sut)
        XCTAssertEqual(sut.pageIndex, index)
        XCTAssertEqual(sut.viewControllers?.count, 1)
        XCTAssertEqual(slide.item.id, startItem.id)
    }
}

// MARK: handleTimeout
extension CampaignCarouselViewControllerTests {
    func test_handleTimeout_doesNotProceed_WhenIndexExceedsPages() throws {
        let items = stubs
        let index = 0
        let startItem = items[index]
        let sut = CampaignCarouselViewController(items: items, startItem: startItem, durationPerSlide: 0)
        _ = sut.view
        
        var closesCarousel = false
        var moveCount = 0
        sut.onExit = { closesCarousel = true }
        sut.onNext = { _ in moveCount += 1 }
        
        sut.pageIndex = stubs.count
        sut.handleTimeout()

        XCTAssertEqual(closesCarousel, false)
        XCTAssertEqual(moveCount, 0)
    }
    
    func test_handleTimeout_closesCarousel_AfterLastSlideFinishedDisplayed() throws {
        let items = stubs
        let index = 0
        let startItem = items[index]
        let sut = CampaignCarouselViewController(items: items, startItem: startItem, durationPerSlide: 0)
        _ = sut.view
        
        var carouselClosed = false
        var moveCount = 0
        sut.onExit = { carouselClosed = true }
        sut.onNext = { _ in moveCount += 1 }
        
        sut.pageIndex = stubs.count - 1
        sut.handleTimeout()

        XCTAssertTrue(carouselClosed)
        XCTAssertEqual(moveCount, 0)
    }
    
    func test_handleTimeout_incrementsIndex() throws {
        let items = stubs
        let index = 0
        let startItem = items[index]
        let sut = CampaignCarouselViewController(items: items, startItem: startItem, durationPerSlide: 0)
        _ = sut.view
        
        var moveCount = 0
        sut.onNext = { _ in moveCount += 1 }

        sut.handleTimeout()
        XCTAssertEqual(sut.pageIndex, 1)
        
        sut.handleTimeout()
        XCTAssertEqual(sut.pageIndex, 2)
    }
    
    func test_handleTimeout_movesToNextSlide_IfNotOnLastSlide() throws {
        let items = stubs
        let index = 0
        let startItem = items[index]
        let sut = CampaignCarouselViewController(items: items, startItem: startItem, durationPerSlide: 0)
        _ = sut.view
        
        var carouselClosed = false
        var moveCount = 0
        sut.onExit = { carouselClosed = true }
        sut.onNext = { _ in moveCount += 1 }
        
        sut.handleTimeout()
        
        let currentSlideItem = currentSlide(in: sut).item
        let expectedSlideItem = stubs[sut.pageIndex]
        
        XCTAssertEqual(sut.pageIndex, index + 1)
        XCTAssertEqual(currentSlideItem?.id, expectedSlideItem.id)
        XCTAssertEqual(carouselClosed, false)
        XCTAssertEqual(moveCount, 1)
    }
}

// MARK: Data source
extension CampaignCarouselViewControllerTests {
    func test_dataSource_swipingLeftFailsReturningNilVc_() throws {
        let items = stubs
        let index = 0
        let startItem = items[index]
        let sut = CampaignCarouselViewController(items: items, startItem: startItem, durationPerSlide: 0)
        _ = sut.view
        
        let slide = sut.makeSlide(with: startItem)
        let nextViewController = sut.pageViewController(sut, viewControllerBefore: slide)
      
        XCTAssertNil(nextViewController)
        XCTAssertEqual(sut.pageIndex, index)
    }
    
    func test_dataSource_swipingRightFailsReturningNilVc_() throws {
        let items = stubs
        let index = stubs.count - 1
        let startItem = items[index]
        let sut = CampaignCarouselViewController(items: items, startItem: startItem, durationPerSlide: 0)
        _ = sut.view
        
        let slide = sut.makeSlide(with: startItem)
        let nextViewController = sut.pageViewController(sut, viewControllerAfter: slide)
      
        XCTAssertNil(nextViewController)
        XCTAssertEqual(sut.pageIndex, index)
    }
}

// MARK: Helpers
extension CampaignCarouselViewControllerTests {
    func currentSlide(in pageController: UIPageViewController) -> CampaignCarouselSlide {
        guard let slide = pageController.viewControllers?.first as? CampaignCarouselSlide else {
            fatalError("There is currently no viewcontroller in UIPageViewController's view controllers or the view controller you tried to access is not type of \(String(describing: CampaignCarouselSlide.self))")
        }
        return slide
    }
}

// MARK: Stubs
extension CampaignCarouselViewControllerTests {
    var stubs: [CampaignViewModel] {
        return [
            .init(id: "1", image: "kampanya", link: nil, read: true),
            .init(id: "2", image: "kampanya", link: nil, read: false),
            .init(id: "3", image: "kampanya", link: nil, read: false)
        ]
    }
}
