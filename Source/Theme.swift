//
//  StoriesUI.swift
//  LandOfStories
//
//  Created by Dominik Vesely on 08/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ACKategories





extension UIFont {
    enum FontStyle: String {
        case Regular = "Helvetica"

        func font(withSize size: CGFloat = 13) -> UIFont {
            return UIFont(name: rawValue, size: size)!
        }
    }
    class func mainRegular(size: CGFloat) -> UIFont {
        return FontStyle.Regular.font(withSize: size)
    }
}




extension UIColor {

	class func gayColor() -> UIColor {
		return UIColor(hex: 0xFF1493)
	}

    class func defaultTextColor() -> UIColor {
        return UIColor.blackColor()
    }

}

extension UIImage {
    enum ImagesForToggle: String {
        case Lock = "Lock"
    }

    /**
    Toggle on/off on UIButton image.

    - parameter name: enum of names of the images.

    - returns: tuple of images with on/off postfix.
    */
    class func toggleImage(name: ImagesForToggle) -> (on: UIImage!, off: UIImage!) {
        let imageOn = UIImage(named: name.rawValue + "On")
        let imageOff = UIImage(named: name.rawValue + "Off")
        return (imageOn!, imageOff!)
    }
}


/**
 Theme class for creating standard UI elements for the app

*/
class Theme {
    class func blueButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.blueColor()
        return button
    }

    class func label(style: UIFont.FontStyle = .Regular, size: CGFloat = 13, color: UIColor = UIColor.defaultTextColor()) -> UILabel {
        let label = UILabel()

        label.font = UIFont(name: style.rawValue, size: size)
        label.textColor = color

        return label
    }
}
