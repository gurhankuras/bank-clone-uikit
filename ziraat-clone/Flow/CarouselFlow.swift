//
//  CarouselFlow.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/31/22.
//

import Foundation
import UIKit

protocol Flow {
    func start()
    var cleanUp: (() -> Void)? { get set }
}

class CarouselFlow: Flow {
    var cleanUp: (() -> Void)?
    let navigationController: UINavigationController
    let startItem: CampaignViewModel
    let items: [CampaignViewModel]
    let nextHandler: (CampaignViewModel) -> Void
    // let campaignStore: CampaignStore
    
    deinit {
        log_deinit(Self.self)
    }
    
    init(_ navigationController: UINavigationController,
         startingAt item: CampaignViewModel,
         among allItems: [CampaignViewModel],
         nextHandler: @escaping (CampaignViewModel) -> Void
         /*campaignStore: CampaignStore*/) {
        self.navigationController = navigationController
        self.startItem = item
        self.items = allItems
        self.nextHandler = nextHandler
//        self.campaignStore = campaignStore
    }
    
    func start() {
        showCarousel()
    }
    
    func showCarousel() {
        let vc = CampaignCarouselViewController(items: items, startItem: startItem)
        vc.onExit = { [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.cleanUp?()
        }
        vc.onNext = { [weak self] in self?.nextHandler($0) }
        self.navigationController.pushViewController(vc, animated: true)
    }
}
