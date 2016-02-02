//
//  UIView+Spacer.swift
//  Shark
//
//  Created by Petr Šíma on 11/12/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa

extension  UIView {
    private func createSpacer(size size: CGFloat, axis: UILayoutConstraintAxis, priority: Int) -> UIView {
        let v = UIView()
        v.rac_hidden <~ self.rac_hidden
        v.snp_makeConstraints { make in
            switch axis {
            case .Vertical: make.height.equalTo(size).priority(priority)
            case .Horizontal: make.width.equalTo(size).priority(priority)
            }
        }
        return v
    }

    func createVSpacer(height height: CGFloat, priority: Int = 999) -> UIView {
        return createSpacer(size: height, axis: .Vertical, priority: priority)
    }
    func createHSpacer(width width: CGFloat, priority: Int = 999) -> UIView {
        return createSpacer(size: width, axis: .Horizontal, priority: priority)
    }

}
