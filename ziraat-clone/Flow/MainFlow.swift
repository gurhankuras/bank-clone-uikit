//
//  MainFlow.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/22/22.
//

import Foundation
import UIKit
import CoreData
import os.log


class MainFlow {
    var navigationController: UINavigationController
    var carouselFlow: CarouselFlow?
    var requestRecomposition: ((UIViewController) -> Void)?

    // MARK: Dependencies
    lazy var campaignCollectionViewModel: CampaignCollectionViewModel = {
        let versionProvider = CampaignUserDefaultsVersionProvider()
        let api = CampaignAPI(versionProvider: versionProvider)
        let store = campaignStore
        let provider = CampaignCacheRemoteSynchronizer(store: store, remote: api)
        let viewModel = CampaignCollectionViewModel(provider: provider, store: store)
        return viewModel
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var campaignStore = CampaignCoreDataStore(container: self.persistentContainer)
    lazy var languageViewModel = LocalizationViewModel(languageService: languageChanger)
    lazy var languageChanger: LocalizationService = LanguageService(keyValueStore: UserDefaults.standard)
    lazy var birthdayProcessor: BirthdayAppIconProcessor = {
        let manager = AppIconManager(changer: UIApplication.shared, keyValueStore: UserDefaults.standard)
        let processor = BirthdayAppIconProcessor(iconManager: manager,
                                                 comparator: BirthdayComparator.compare,
                                                 timeProvider: { Date() })
        return processor
    }()
    
    deinit { log_deinit(Self.self) }
    
    init(navigationViewController: UINavigationController) {
        self.navigationController = navigationViewController
    }
    
    func start() {
        os_log("Starting main flow...", log: OSLog.flow, type: .debug)
        languageChanger.applyCurrent()
        showLanding()
    }
    
    func showLanding() {
        let vc = rootViewController(in: languageChanger.currentLanguage)
        campaignCollectionViewModel.load()
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func rootViewController(in language: LocalizationLanguage) -> UIViewController {
        let loginCallback: () -> Void = { [weak self] in self?.showLoginSheet() }
        let languageCallback: () -> Void = { [weak self] in self?.presentLanguageSelectionSheet() }
    
                
        let compaingsViewController = Factory.makeCampaignsViewController(viewModel: campaignCollectionViewModel,
        onCampaignSelected: { [weak self] item in
            self?.startCarouselFlow(startingAt: item)
        })
        
        let vc = Factory.makeLandingViewController(language: language, loginButtonPressed: loginCallback,
                                                   onLanguagePressed: languageCallback,
                                                   campaignsViewController: compaingsViewController)
        vc.processBirthday = { [weak self] in
            
            self?.birthdayProcessor.process(birthdayOf: .stub)
        }
        return vc
    }

    private func showHome() {
        let home = Factory.makeHomeViewController { [weak self] in self?.pop() }
        navigationController.pushViewController(home, animated: true)
    }

}

// MARK: Login
extension MainFlow {
    func pressLogin() {
        navigationController.dismiss(animated: true, completion: { [weak self] in self?.showHome() })
    }
    
    func showLoginSheet() {
        let vc = Factory.makeLoginViewController(onClose: { [weak self] in self?.dismiss() },
                                                 onLoginButtonPressed: { [weak self] in self?.pressLogin() })
        vc.modalPresentationStyle = .custom
        vc.view.layer.cornerRadius = 20
        vc.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        vc.view.backgroundColor = .white
        navigationController.present(vc, animated: true)
    }
}

// MARK: Flows
extension MainFlow {
    func startCarouselFlow(startingAt item: CampaignViewModel) {
        // let store = CampaignCoreDataStore(container: persistentContainer)
        carouselFlow = CarouselFlow(
            navigationController,
            startingAt: item,
            among: campaignCollectionViewModel.campaignViewModels,
            nextHandler: { [weak self] item in
                self?.campaignCollectionViewModel.markAsReadIfNeeded(item)
            },
          campaignStore: campaignStore
        )
        carouselFlow?.cleanUp = { [weak self] in self?.carouselFlow = nil }
        carouselFlow?.start()
    }
}

// MARK: language
extension MainFlow {
    private func presentLanguageSelectionSheet() {
        let vc = LanguageSelectionViewController()
        vc.viewModel = languageViewModel
        vc.didSelectLanguage = { [weak self] lang in
            func recomposeUI() {
                guard let self = self else { return }
                let vc = self.rootViewController(in: lang)
                self.navigationController = UINavigationController(rootViewController: vc)
                self.requestRecomposition?(self.navigationController)
            }
            self?.navigationController.dismiss(animated: true, completion: recomposeUI)
        }
        vc.modalPresentationStyle = .custom
        navigationController.present(vc, animated: true)
    }
}

// MARK: Helpers
extension MainFlow {
    private func dismiss() {
        navigationController.dismiss(animated: true)
    }

    private func pop() {
        navigationController.popViewController(animated: true)
    }
}
