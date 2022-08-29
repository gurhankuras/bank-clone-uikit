//
//  SceneDelegate.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/28/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainFlow: MainFlow!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene
        
        let navigationController = UINavigationController()
        navigationController.delegate = self

        mainFlow = MainFlow(navigationViewController: navigationController)
        mainFlow.requestRecomposition = { [weak self] rootViewController in
            self?.window?.rootViewController = rootViewController
            
        }
        mainFlow.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
   
    
    
    
    
}

extension SceneDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            if toVC is HomePageViewController {
                return MoveUpPageTransition(movement: .up, duration: 0.4)
            }
            return nil
        }
}


