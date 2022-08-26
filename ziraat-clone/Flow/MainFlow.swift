//
//  MainFlow.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/22/22.
//

import Foundation
import UIKit

class MainFlow {
    var requestRecomposition: ((UIViewController) -> Void)?
    var navigationViewController: UINavigationController

    init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
    }

    func start() {
        showLanding()
        //showHome()
    }
    func showLanding() {
        let vc = rootViewController()
        navigationViewController.setViewControllers([vc], animated: true)
    }
    
    private func rootViewController() -> UIViewController {
        let loginCallback: () -> Void =  { [weak self] in self?.showLoginSheet() }
        let languageCallback: () -> Void = { [weak self] in self?.presentLanguageSelectionSheet() }
        let vc = Factory.makeLandingViewController(loginButtonPressed: loginCallback, onLanguagePressed: languageCallback)
        return vc
    }
    
    func showLoginSheet() {
        let vc = Factory.makeLoginViewController(onClose: { [weak self] in self?.dismiss() },
                                                 onLoginButtonPressed: { [weak self] in self?.pressLogin() })
        vc.modalPresentationStyle = .custom
        vc.view.layer.cornerRadius = 20
        vc.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        vc.view.backgroundColor = .white
        navigationViewController.present(vc, animated: true)
    }
    
    private func presentLanguageSelectionSheet() {
        let vc = LanguageSelectionViewController()
        vc.didSelectLanguage = { [weak self] lang in
            print("\(lang.rawValue) selected")
            self?.navigationViewController.dismiss(animated: true, completion: {
                guard let self = self else { return }
                let vc = self.rootViewController()
                self.navigationViewController = UINavigationController(rootViewController: vc)
                self.requestRecomposition?(self.navigationViewController)
                //self?.showHome()

            })
        }
        vc.modalPresentationStyle = .custom
        vc.view.backgroundColor = .white
        navigationViewController.present(vc, animated: true)
    }
    
    func pressLogin() {
        navigationViewController.dismiss(animated: true, completion: { [weak self] in self?.showHome() })
    }
    
    private func showHome() {
        let home = Factory.makeHomeViewController { [weak self] in self?.pop() }
        navigationViewController.pushViewController(home, animated: true)
    }
    
    private func dismiss() {
        navigationViewController.dismiss(animated: true)
    }
    
    private func pop() {
        navigationViewController.popViewController(animated: true)
    }
}
