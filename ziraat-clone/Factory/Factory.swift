//
//  Factory.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/22/22.
//

import Foundation
import UIKit

class Factory {
    static func makeLoginViewController(onClose: @escaping () -> Void,
                                        onLoginButtonPressed: @escaping () -> Void) -> UIViewController {
        let loginVc = LoginViewController()
        // let result: LoginViewModel.Result<Error> =  .error(LoginViewModel.LoginError.badFormattedPassword(""))
        let result: LoginViewModel.Result<Error> = .success
        let loginService = LoginServiceStub(result: result)
        let accountHolder = AccountHolder.stub
        loginVc.viewModel = LoginViewModel(service: loginService, accountHolder: accountHolder)
        loginVc.onClose = onClose
        loginVc.onLogin = onLoginButtonPressed

        return loginVc
    }

    static func makeHomeViewController(onExit: @escaping () -> Void) -> UIViewController {
        let homeVc = HomePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        homeVc.onExit = onExit
        return homeVc
    }

    static func makeLandingViewController(language: LocalizationLanguage,
                                          loginButtonPressed: @escaping () -> Void,
                                          onLanguagePressed: @escaping () -> Void,
                                          campaignsViewController: CampaignListViewController) -> LandingViewController {
        let landingVc = LandingViewController(accountHolder: AccountHolder.stub, language: language)
        landingVc.campaigns = campaignsViewController
        landingVc.onLoginPressed = loginButtonPressed
        landingVc.onLanguagePressed = onLanguagePressed
//        landingVc.onCampaignSelected = onCampaignSelected

        return landingVc
    }
    
    static func makeCampaignsViewController(
        viewModel: CampaignCollectionViewModel,
        onCampaignSelected: @escaping (CampaignViewModel) -> Void)
    -> CampaignListViewController {
        let vc = CampaignListViewController(viewModel: viewModel)
        vc.onCampaignSelected = onCampaignSelected
        return vc
    }
}
