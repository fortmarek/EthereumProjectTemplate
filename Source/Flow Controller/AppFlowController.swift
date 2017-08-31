//
//  ScreenFlowManager.swift
//  Kosik
//
//  Created by Lukáš Hromadník on 26.05.17.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Hero
import UIKit
import ACKategories
import ReactiveSwift

final class AppFlowController: FlowController, OnboardingFlowControllerDelegate, CheckoutFlowControllerDelegate {
    
    private let (lifetime, token) = Lifetime.make()
    
    private let window: UIWindow
    private let userDataStorage: UserDataStorage
    private let userManager: UserManaging
    private let orderManager: OrderManaging
    private let versionUpdateManager: VersionUpdateManaging
    private weak var tabBarVC: UITabBarController?
    
    var childControllers: [FlowController] = []
    
    private weak var shopFlow: ShopFlowController?
    
    // MARK: Initializers
    
    init(userDataStorage: UserDataStorage, userManager: UserManaging, orderManager: OrderManaging, versionUpdateManager: VersionUpdateManaging, window: UIWindow) {
        self.window = window
        self.userManager = userManager
        self.userDataStorage = userDataStorage
        self.orderManager = orderManager
        self.versionUpdateManager = versionUpdateManager
    }
    
    // MARK: Public interface
    
    func start() {
        setupRootViewController(animated: false)
        setupBindings()
    }
    
    func handle(action: RoutingAction) {
        guard let tab = tabBarVC else { return }
        switch action {
        case .search:
            tab.selectedIndex = 1
        case .checkout:
            tab.selectedIndex = 2
        default: break
        }
    }
    
    // MARK: CheckoutFlowController delegate
    
    func open(category: Int, from flowController: CheckoutFlowController) {
        tabBarVC?.selectedIndex = 0
        shopFlow?.showCategory(with: category)
    }
    
    func openShop() {
        tabBarVC?.selectedIndex = 0
    }
    
    // MARK: OnboardingFlowController delegate
    
    func didFinishFlow(of flowController: OnboardingFlowController) {
        userDataStorage.onboardingFinished = true
        setupRootViewController(animated: true)
        removeChild(flowController)
    }
    
    // MARK: Private helpers
    
    private func setupRootViewController(animated: Bool) {
        if !userDataStorage.onboardingFinished {
            let navigationController = UINavigationController()
            replaceRootViewController(vc: navigationController, animated: animated)
            
            let flowController = OnboardingFlowController(navigationController: navigationController)
            flowController.delegate = self
            addChild(flowController)
            flowController.start()
            
        } else {
            let tabVC = UITabBarController()
            self.tabBarVC = tabVC
            
            //Create tab bar
            
            let shopNav = UINavigationController()
            let searchNav = UINavigationController()
            let checkoutNav = UINavigationController()
            let profileNav = UINavigationController()
            
            tabVC.viewControllers = [shopNav, searchNav, checkoutNav, profileNav]
            tabVC.viewControllers?.forEach { _ = $0.view } // workaround for interactivePopGestureRecognizer to be installed
            
            //Setup flows
            
            let shopFlow = ShopFlowController(navigationController: shopNav)
            addChild(shopFlow)
            shopFlow.start()
            self.shopFlow = shopFlow
            
            let searchFlow = SearchFlowController(navigationController: searchNav)
            addChild(searchFlow)
            searchFlow.start()
            
            let checkoutFlow = CheckoutFlowController(navigationController: checkoutNav, userManager: userManager, orderManager: orderManager)
            checkoutFlow.delegate = self
            addChild(checkoutFlow)
            checkoutFlow.start()
            
            let profileFlow = ProfileFlowController(navigationController: profileNav)
            addChild(profileFlow)
            profileFlow.start()
            
            replaceRootViewController(vc: tabVC, animated: animated)
        }
    }
    
    private func replaceRootViewController(vc: UIViewController, animated: Bool) {
        if animated {
            window.rootViewController?.view.heroModifiers = HeroModifier.rootChangeModifiers.to
            vc.view.heroModifiers = HeroModifier.rootChangeModifiers.from
            window.rootViewController?.hero_replaceViewController(with: vc)
        } else {
            window.rootViewController = vc
        }
    }
    
    private func setupBindings() {
        orderManager.didInsertFirstProduct.observe(on: UIScheduler()).take(during: lifetime).observeValues { [unowned self] in
            let loc = L10n.AddProduct.NotLoggedIn.self
            let popup = PopupViewController(image: UIImage(asset: .imgProfileNotSignedIn), title: loc.title, message: loc.message)
            let frontVC = self.window.rootViewController?.frontmostController
            let login = PopupViewController.Action(title: loc.confirm, style: .red) { [weak popup, unowned self] in
                let welcomeVC = self.router.prepare(vc: WelcomeViewController.self)
                let welcomeNav = UINavigationController(rootViewController: welcomeVC)
                
                welcomeNav.makeWelcome()
                popup?.dismiss(animated: true, completion: nil)
            }
            let cancel = PopupViewController.Action(title: loc.cancel, style: .white) { [weak popup] in
                popup?.dismiss(animated: true, completion: nil)
            }
            popup.addAction(login)
            popup.addAction(cancel)
            
            if let baseVC = frontVC as? BaseViewController {
                baseVC.present(popup: popup)
            } else {
                frontVC?.present(popup, animated: true, completion: nil)
            }
        }
        
        
        
        SignalProducer.zip(versionUpdateManager.updateRequired.producer, versionUpdateManager.updateAvailable.producer).startWithValues { required, available in
            
            if required {
                let loc = L10n.ForceUpdate.self
                let popup = PopupViewController(image: UIImage(asset: .imgForceUpdate), title: nil, message: loc.message, mode: .full)
                let confirm = PopupViewController.Action(title: loc.button, style: .red) { [unowned self] in
                    self.openStore()
                }
                popup.addAction(confirm)
                self.replaceRootViewController(vc: popup, animated: true)
            } else if available {
                
                let loc = L10n.UpdateDialog.self
                let popup = PopupViewController(image: UIImage(asset: .imgUpdate), title: nil, message: loc.message)
                let confirm = PopupViewController.Action(title: loc.download, style: .red) { [weak popup, unowned self] in
                    self.openStore()
                    popup?.dismiss(animated: true, completion: nil)
                }
                let cancel = PopupViewController.Action(title: loc.notNow, style: .gray) { [weak popup] in
                    popup?.dismiss(animated: true, completion: nil)
                }
                popup.addAction(confirm)
                popup.addAction(cancel)
                
                (self.window.rootViewController?.frontmostController as? BaseViewController)?.present(popup: popup)
            }
        }
    }
    
    func openStore() {
        let link = self.versionUpdateManager.itunesLink.value
        
        if let url = URL(string: "itms-apps://" + (link ?? "")) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
