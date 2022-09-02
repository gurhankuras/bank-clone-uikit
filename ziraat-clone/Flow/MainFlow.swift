//
//  MainFlow.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/22/22.
//

import Foundation
import UIKit

class MainFlow {
    var navigationController: UINavigationController
    var carouselFlow: CarouselFlow?
    var requestRecomposition: ((UIViewController) -> Void)?

    // MARK: Dependencies
    lazy var campaignCollectionViewModel: CampaignCollectionViewModel = {
        let provider = CampaignAPI()
        let viewModel = CampaignCollectionViewModel(provider: provider)
        return viewModel
    }()
    lazy var languageViewModel = LanguageViewModel(languageService: languageChanger)
    lazy var languageChanger: AppLanguageUser = AppLanguageService()
    
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
    
    private func rootViewController(in language: Language) -> UIViewController {
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
        carouselFlow = CarouselFlow(
            navigationController,
            startingAt: item,
            among: campaignCollectionViewModel.campaignViewModels,
            nextHandler: { [weak self] item in
                self?.campaignCollectionViewModel.markAsRead(id: item.id)
            })
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
