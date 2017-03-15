//
//  UIView+Spacer.swift
//  ProjectSkeleton
//
//  Created by Petr Šíma on 11/12/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

extension  UIView {
    fileprivate func createSpacer(_ size: CGFloat, axis: UILayoutConstraintAxis, priority: Int) -> UIView {
        let v = UIView()
//        v.reactive.isHidden <~ self.rac_hidden.producer
        v.snp.makeConstraints { make in
            switch axis {
            case .vertical: make.height.equalTo(size).priority(priority)
            case .horizontal: make.width.equalTo(size).priority(priority)
            }
        }
        return v
    }

    func createVSpacer(_ height: CGFloat, priority: Int = 999) -> UIView {
        return createSpacer(height, axis: .vertical, priority: priority)
    }
    func createHSpacer(_ width: CGFloat, priority: Int = 999) -> UIView {
        return createSpacer(width, axis: .horizontal, priority: priority)
    }

}
