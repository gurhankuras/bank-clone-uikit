//
//  CustomPageController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/30/22.
//

import UIKit
import OSLog

class CampaignCarouselViewController: UIPageViewController {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: "CampaignCarouselViewController"))
    var onExit: (() -> Void)?
    var onNext: ((CampaignViewModel) -> Void)?
    var pageIndex = 0 {
        didSet {
            print(pageIndex)
        }
    }
    
    var items: [CampaignViewModel] = []
    var startItem: CampaignViewModel!

    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }

    convenience init(items: [CampaignViewModel], startItem: CampaignViewModel) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.startItem = startItem
        self.items = items
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { log_deinit(Self.self) }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        dataSource = self
        delegate = self
        if let startIndex = items.firstIndex(of: startItem) {
            pageIndex = startIndex
        } else {
            fatalError("startItem is not one of the items has been passed")
        }
        setViewControllers([makeSlide(with: startItem)], direction: .forward, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
                     
    func handleTimeout() {
        guard self.pageIndex < self.items.count else { return }
        if self.pageIndex == self.items.count - 1 {
            onExit?()
        } else {
            let item = items[self.pageIndex + 1]
            onNext?(item)
            self.setViewControllers([makeSlide(with: item)], direction: .forward, animated: true)
        }

        self.pageIndex += 1
    }
    
    private func campaignItem(for viewController: UIViewController) -> CampaignViewModel? {
        let campaignVc = viewController as? CampaignCarouselSlide
        return campaignVc?.item
    }
    
    func makeSlide(with item: CampaignViewModel) -> CampaignCarouselSlide {
        let slide = CampaignCarouselSlide(item: item, onTimeout: { [weak self] in self?.handleTimeout() })
        slide.onExit = { [weak self] in self?.onExit?() }
        return slide
    }
}
                     
extension CampaignCarouselViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        Self.logger.debug("\(#function)")
        guard let currentItem = campaignItem(for: viewController),
              let currentIndex = items.firstIndex(of: currentItem) else { return nil }
        pageIndex = currentIndex
        onNext?(currentItem)
        if currentIndex == 0 {
            return nil
        }
        return makeSlide(with: items[currentIndex - 1])
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let item = campaignItem(for: viewController),
              let currentIndex = items.firstIndex(of: item) else { return nil }
        pageIndex = currentIndex
        onNext?(item)
        if currentIndex < items.count - 1 {
            return makeSlide(with: items[currentIndex + 1])
        }
        return nil
    }
}

extension CampaignCarouselViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        print("willTransitionTo")
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let viewControllers = pageViewController.viewControllers,
              let item = campaignItem(for: viewControllers.first!),
              let currentIndex = items.firstIndex(of: item) else { return }
        guard completed else { return }
        pageIndex = currentIndex
        
        /*
        previousViewControllers
            .compactMap({ $0 as? CampaignPageViewControllerSlide })
            .filter({ $0.item.image != (pages[currentIndex] as! CampaignPageViewControllerSlide).item.image})
            .forEach { slide in
                slide.reset()
            }
        */
    }
}
