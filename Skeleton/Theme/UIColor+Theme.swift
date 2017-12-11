//
//  UIColor+Theme.swift
//  Skeleton
//
//  Created by Jakub Olejník on 09/12/2017.
//

import UIKit

extension UIColor: ThemeProvider { }

extension Theme where Base: UIColor { // all app colors should be available in UIColor.theme namespace
    static var ackeeBlue: UIColor { return .blue }
}

// just an example
//extension UIColor { // if you want to use short dot syntax, it should be just a shortcut to Theme namespace
//    static var ackeeBlue: UIColor { return UIColor.theme.ackeeBlue }
//}
