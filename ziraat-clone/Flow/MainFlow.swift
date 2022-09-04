//
//  MainFlow.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/22/22.
//

import Foundation
import UIKit
import CoreData

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
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var campaignStore = CampaignCoreDataStore(container: self.persistentContainer)
    lazy var languageViewModel = LocalizationViewModel(languageService: languageChanger)
    lazy var languageChanger: LocalizationService = LanguageService(keyValueStore: UserDefaults.standard)
    
    deinit { log_deinit(Self.self) }
    
    init(navigationViewController: UINavigationController) {
        self.navigationController = navigationViewController
    }

    func start() {
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
        //let store = CampaignCoreDataStore(container: persistentContainer)
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
