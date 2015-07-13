//
//  StoriesUI.swift
//  LandOfStories
//
//  Created by Dominik Vesely on 08/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation



extension UIFont {
    
    class func mainRegular(size : CGFloat) -> UIFont! {
        return UIFont(name: "Main", size: size)!
    }
    
    class func mainLight(size : CGFloat) -> UIFont! {
        return UIFont(name: "Main-Light", size: size)!
    }
    
    class func printAllFonts() {
        for item in UIFont.familyNames() {
            let names = UIFont.fontNamesForFamilyName(item as! String)
            println("\(item): \(names)")
        }
    }
}




extension UIColor {
    
    class func mainColor() -> UIColor! {
        return UIColor(hex: 0x0000000)
    }
    
    class func rekolaGreenColor() -> UIColor! {
        return UIColor(hex: 0x7d8d38)
    }
    
    class func rekolaPinkColor() -> UIColor! {
        return UIColor(hex: 0xfd349c)
    }
    
    class func rekolaGreyColor() -> UIColor! {
        return UIColor(hex: 0xececec)
    }
    
}

extension UIImage {
    enum ImageIdentifier: String {
        case LockOff = "LockOff"
        case LockOn = "LockOn"
        case MapOff = "MapOff"
        case MapOn = "MapOn"
        case ProfileOff = "ProfileOff"
        case ProfileOn = "ProfileOn"
    }
    
    convenience init!(imageIdentifier: ImageIdentifier) {
        self.init(named: imageIdentifier.rawValue)
    }
    
    enum ImagesForToggle: String {
        case Lock = "Lock"
        case Map = "Map"
        case Profile = "Profile"
    }
    
    /**
    Toggle on/off on UIButton image.
    
    :param: name enum of names of the images.
    
    :returns: tuple of images with on/off postfix.
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
    class func blueButton() -> UIButton? {
        let button = UIButton()
        button.backgroundColor = UIColor.blueColor()
        return button
    }
    
    class func pinkButton() -> UIButton? {
        let button = UIButton()
        button.backgroundColor = UIColor.rekolaPinkColor()
        return button
    }
    
    class func greenButton() -> UIButton? {
        let button = UIButton()
        button.backgroundColor = UIColor.rekolaGreenColor()
        return button
    }
    
    class func greenBorderButton() -> UIButton? {
        let button = UIButton()
        button.layer.borderColor = UIColor.rekolaGreenColor().CGColor
        button.setTitleColor(UIColor.rekolaGreenColor(), forState: .Normal)
        return button
    }
    
    class func whiteButton() -> UIButton? {
        let button = UIButton()
        button.setTitleColor(UIColor.rekolaGreenColor(), forState: .Normal)
        return button
    }
}
    
