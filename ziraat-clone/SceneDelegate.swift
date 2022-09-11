//
//  SceneDelegate.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 7/28/22.
//

import UIKit
import OSLog
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

    var visualEffectView = UIVisualEffectView()

    func sceneWillEnterForeground(_ scene: UIScene) {
        print(#function)
        visualEffectView.removeFromSuperview()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print(#function)
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print(#function)
        guard let window = window else { return }

        if !self.visualEffectView.isDescendant(of: window) {
            let blurEffect = UIBlurEffect(style: .systemThinMaterial)
            self.visualEffectView = UIVisualEffectView(effect: blurEffect)
            self.visualEffectView.frame = (self.window?.bounds)!
            self.window?.addSubview(self.visualEffectView)
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print(#function)
        self.visualEffectView.removeFromSuperview()
    }
    
    /*
    override func sceneWillResignActive(_ application: UIApplication) {
        guard let window = window else {
            return
        }

    if !self.visualEffectView.isDescendant(of: window) {
        let blurEffect = UIBlurEffect(style: .light)
        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.visualEffectView.frame = (self.window?.bounds)!
        self.window?.addSubview(self.visualEffectView)
       }
    }
    override func sceneDidBecomeActive(_ application: UIApplication) {
        self.visualEffectView.removeFromSuperview()
    }
     */

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
