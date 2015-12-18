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
    
    class func mainRegular(size : CGFloat) -> UIFont! {
        return UIFont(name: "Main", size: size)!
    }
    
    class func mainLight(size : CGFloat) -> UIFont! {
        return UIFont(name: "Main-Light", size: size)!
    }
    
    class func printAllFonts() {
        for item in UIFont.familyNames() {
            let names = UIFont.fontNamesForFamilyName(item )
            print("\(item): \(names)")
        }
    }
}




extension UIColor {
    
	class func gayColor() -> UIColor {
		return UIColor(hex: 0xFF1493)
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
}
    
