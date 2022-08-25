//
//  HomeViewController.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/29/22.
//

import Foundation
import UIKit

class HomePageViewController: UIPageViewController {
    var onExit: (() -> Void)?
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named: "th")?.cgImage
        self.view.layer.contentsGravity = .resizeAspectFill
        //view.backgroundColor = .darkGray
        configureNavigationBar()
        dataSource = self
        delegate = self
       
        
        pageControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        
        let pink = AccountsViewController()
        
        let green = MyAssetsViewController()
        
        let orange = UIViewController()
        orange.view.backgroundColor = .orange
        
        
        pages.append(contentsOf: [pink, green, orange])
        setViewControllers([pages[pageIndex]], direction: .forward, animated: true)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = pageIndex
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            //make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-10)

            make.height.equalTo(30)
        }
        
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.topAnchor, multiplier: 1)
        ])
        
        
    }
    
    @objc func indexChanged(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
    
    
    
    
    
    @objc func exit() {
        onExit?()
    }
}


// MARK: Navigation bar configuration
extension HomePageViewController {
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        
        // MARK: bar left item
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), style: .done, target: self, action: #selector(exit))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        // MARK: navigation title
        let navigationTitle = UILabel()
        navigationTitle.text = "Accounts"
        let navigationTitleString = NSMutableAttributedString(string: "Accounts")
        let range = NSRange(location: 0, length: navigationTitleString.length)
        navigationTitleString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        navigationTitleString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: range)
        navigationTitle.attributedText = navigationTitleString
        navigationItem.titleView = navigationTitle
        
        // MARK: bar right item
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .done, target: self, action: #selector(exit))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}

extension HomePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == 0 {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        }
        return nil
    }
}

extension HomePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers.first!) else { return }
        pageControl.currentPage = currentIndex
    }
}



