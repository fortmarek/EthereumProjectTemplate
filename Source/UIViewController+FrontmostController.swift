//
//  UIViewController+FrontmostController.swift
//  SampleTestingProject
//
//  Created by Petr Šíma on 28/03/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import UIKit



extension UIViewController {
    private var frontmostChild : UIViewController? {
        switch self {
        case let s as UISplitViewController: return s.viewControllers.last
        case let n as UINavigationController: return n.topViewController
        case let t as UITabBarController: return t.selectedViewController
        //Add cases for your app's container controllers...
        default: return nil
        }
    }
    
    var frontmostController : UIViewController {
        return presentedViewController?.frontmostController ??
            frontmostChild?.frontmostController
            ?? self
    }
}


