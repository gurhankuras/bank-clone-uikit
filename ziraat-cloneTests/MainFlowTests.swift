//
//  MainFlowTests.swift
//  ziraat-cloneTests
//
//  Created by Gürhan Kuraş on 8/22/22.
//

import XCTest
@testable import ziraat_clone

class NonAnimatingNavigationController: UINavigationController {
    var presentViewController: UIViewController?
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: false)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: false, completion: completion)
        presentViewController = nil
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        super.popViewController(animated: false)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: false, completion: completion)
        presentViewController = viewControllerToPresent
    }
}

class MainFlowTests: XCTestCase {

    func test_flowStartsWithLanding() throws {
        let sut = MainFlow(navigationViewController: NonAnimatingNavigationController())
        sut.start()
        XCTAssertEqual(sut.navigationViewController.viewControllers.count, 1)
        XCTAssertTrue(sut.navigationViewController.viewControllers.first! is LandingViewController)
    }
    
    func test_showsLanding() throws {
        let sut = MainFlow(navigationViewController: NonAnimatingNavigationController())
        sut.showLanding()
        XCTAssertEqual(sut.navigationViewController.viewControllers.count, 1)
        XCTAssertTrue(sut.navigationViewController.viewControllers.first! is LandingViewController)
    }
    
    func test_presentsLoginSheetCorrectly() throws {
        let navController = NonAnimatingNavigationController()
        let sut = MainFlow(navigationViewController: navController)
        sut.start()
        
        XCTAssertNil(navController.presentViewController)
        
        sut.showLoginSheet()
        
        XCTAssertNotNil(navController.presentViewController)
        XCTAssertEqual(navController.viewControllers.count, 1)
        XCTAssertTrue(navController.presentViewController is LoginViewController)
    }
    
    func test_pressingLoginPushesHome() throws {
        let navController = NonAnimatingNavigationController()
        let sut = MainFlow(navigationViewController: navController)
        sut.start()
        
        sut.pressLogin()

        XCTAssertEqual(navController.viewControllers.count, 2)
        XCTAssertTrue(navController.topViewController is HomePageViewController)
    }
    
    func test_pressingLoginDismissesModal() throws {
        let navController = NonAnimatingNavigationController()
        let sut = MainFlow(navigationViewController: navController)
        sut.start()
        
        navController.present(UIViewController(), animated: false)
        XCTAssertNotNil(navController.presentViewController)
        sut.pressLogin()
        XCTAssertNil(navController.presentViewController)
    }
    
    
    


}
