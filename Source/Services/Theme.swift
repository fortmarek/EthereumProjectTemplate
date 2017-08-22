//
//  Theme.swift
//  ProjectSkeleton
//
//  Created by Dominik Vesely on 08/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ACKategories

extension UIFont {
    fileprivate static let defaultSize: CGFloat = 13
    
    enum FontStyle: String {
        case regular = "Helvetica"

        func font(with size: CGFloat = UIFont.defaultSize) -> UIFont {
            return UIFont(name: rawValue, size: size)!
        }
    }
}

extension UIColor {
    static var gay: UIColor { return UIColor(hex: 0xFF1493) }
    static var defaultText: UIColor { return .black }
}

extension UILabel {
    func makeDefault(style: UIFont.FontStyle = .regular, size: CGFloat = UIFont.defaultSize, color: UIColor? = nil) {
        font = style.font(with: size)
        
        if let color = color { textColor = color }
    }
}
