//
//  Theme+Font.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 23/08/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import UIKit

extension UIFont {
    fileprivate static let defaultSize: CGFloat = 13
    
    enum FontStyle: String {
        case regular = "Helvetica"
        
        func font(with size: CGFloat = UIFont.defaultSize) -> UIFont {
            return UIFont(name: rawValue, size: size)!
        }
    }
}
