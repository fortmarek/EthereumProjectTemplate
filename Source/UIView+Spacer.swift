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
    func createSpacer(height height: CGFloat, priority: Int = 999) -> UIView {
        let v = UIView()
        v.rac_hidden <~ self.rac_hidden
        v.snp_makeConstraints { make in
            make.height.equalTo(height).priority(priority)
        }
        return v
    }
}