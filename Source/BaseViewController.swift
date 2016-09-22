//
//  BaseViewController.swift
//  ProjectSkeleton
//
//  Created by Petr Šíma on 10/04/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func loadView() {
        let view = UIView(); view.backgroundColor = .whiteColor(); view.opaque = true; self.view = view
    }
}
