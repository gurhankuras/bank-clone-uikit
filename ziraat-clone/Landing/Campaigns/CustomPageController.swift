//
//  CustomPageController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/30/22.
//

import UIKit
import OSLog

class CustomPageViewController: UIPageViewController {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                       category: String(describing: "CustomPageViewController"))
    var onExit: (() -> Void)?
    var pageIndex = 0 {
        didSet {
            print(pageIndex)
        }
    }
    
    var items: [CampaignItem] = []
    var startItem: CampaignItem!

    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }

    convenience init(items: [CampaignItem], startItem: CampaignItem) {
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
            self.dismiss(animated: true)
        } else {
            self.setViewControllers([makeSlide(with: items[self.pageIndex + 1])], direction: .forward, animated: true)
        }
        self.pageIndex += 1
    }
    
    func campaignItem(for viewController: UIViewController) -> CampaignItem? {
        let campaignVc = viewController as? CampaignPageViewControllerSlide
        return campaignVc?.item
    }
    
    func makeSlide(with item: CampaignItem) -> CampaignPageViewControllerSlide {
        let slide = CampaignPageViewControllerSlide(item: item, onTimeout: { [weak self] in self?.handleTimeout() })
        slide.onExit = { [weak self] in self?.onExit?() }
        return slide
    }
}
                     
extension CustomPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        Self.logger.debug("\(#function)")
        guard let item = campaignItem(for: viewController),
              let currentIndex = items.firstIndex(of: item) else { return nil }
        pageIndex = currentIndex
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
        if currentIndex < items.count - 1 {
            return makeSlide(with: items[currentIndex + 1])
        }
        return nil
    }
}

extension CustomPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
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
