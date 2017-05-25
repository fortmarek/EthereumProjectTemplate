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
        v.reactive.isHidden <~ reactive.isHiddenProperty
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

extension Reactive where Base: UIView {
    var isHiddenProperty: Property<Bool> {
        return Property(initial: base.isHidden, then: isHiddenSignal)
    }
    
    private var isHiddenSignal: Signal<Bool, NoError> {
        return signal(forKeyPath: "hidden").filterMap { $0 as? Bool }
    }
    
}
