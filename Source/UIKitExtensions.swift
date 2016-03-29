//
//  Util.swift
//  ReactiveTwitterSearch
//
//  Created by Colin Eberhardt on 10/05/2015.
//  Copyright (c) 2015 Colin Eberhardt. All rights reserved.
//

import UIKit
import ReactiveCocoa
//import GoogleMaps
import Result

private struct AssociationKey {
    static var hidden: UInt8 = 1
    static var alpha: UInt8 = 2
    static var text: UInt8 = 3
    static var image: UInt8 = 4
    static var enabled : UInt8 = 5
    static var progress : UInt8 = 6
//    static var position : UInt8 = 7
    static var title : UInt8 = 8
    static var textColor : UInt8 = 9
    static var borderWidth : UInt8 = 10
    static var borderColor : UInt8 = 11
    static var backgroundColor : UInt8 = 12
    static var tintColor : UInt8 = 13
    static var attributedText : UInt8 = 14
    static var animating: UInt8 = 6
    static var selected: UInt8 = 7
}

// lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, _ key: UnsafePointer<Void>, factory: ()->T) -> T {
    var associatedProperty = objc_getAssociatedObject(host, key) as? T
    
    if associatedProperty == nil {
        associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, .OBJC_ASSOCIATION_RETAIN)
    }
    return associatedProperty!
}

func lazyMutableProperty<T>(host: AnyObject, _ key: UnsafePointer<Void>, _ setter: T -> (), _ getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithNext {
                newValue in
                setter(newValue)
        }
        return property
    }
}

extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, &AssociationKey.alpha, { [unowned self] in self.alpha = $0 }, { [unowned self] in self.alpha  })
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, &AssociationKey.hidden, { [unowned self] in self.hidden = $0 }, { [unowned self] in self.hidden  })
    }
    public var rac_tintColor: MutableProperty<UIColor> {
        return lazyMutableProperty(self, &AssociationKey.tintColor, { [unowned self] in self.tintColor = $0 }, { [unowned self] in self.tintColor  })
    }
    public var rac_backgroundColor: MutableProperty<UIColor?> {
        return lazyMutableProperty(self, &AssociationKey.backgroundColor, { [unowned self] in self.backgroundColor = $0 }, { [unowned self] in self.backgroundColor  })
    }
    
}

extension CALayer {
    public var rac_borderWidth: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, &AssociationKey.borderWidth, { [unowned self] in self.borderWidth = $0 }, { [unowned self] in self.borderWidth  })
    }
    public var rac_borderColor: MutableProperty<CGColor?> {
        return lazyMutableProperty(self, &AssociationKey.borderColor, { [unowned self] in self.borderColor = $0 }, { [unowned self] in self.borderColor  })
    }
}

extension UIImageView {
    public var rac_image: MutableProperty<UIImage?> {
        return lazyMutableProperty(self, &AssociationKey.image, { [unowned self] in self.image = $0 }, { [unowned self] in self.image })
    }
}

extension UILabel {
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(self, &AssociationKey.text, { [unowned self] in self.text = $0 }, { [unowned self] in self.text ?? "" })
    }
    public var rac_textColor: MutableProperty<UIColor> {
        return lazyMutableProperty(self, &AssociationKey.textColor, { [unowned self] in self.textColor = $0 }, { [unowned self] in self.textColor })
    }
    public var rac_attributedText: MutableProperty<NSAttributedString> {
        return lazyMutableProperty(self, &AssociationKey.attributedText, { [unowned self] in self.attributedText = $0 }, { [unowned self] in self.attributedText ?? NSAttributedString() })
    }
}

extension UITextField {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, &AssociationKey.text) {
            
            self.addTarget(self, action: "changed", forControlEvents: UIControlEvents.EditingChanged)
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithNext { [unowned self]
                    newValue in
                    self.text = newValue
            }
            return property
        }
    }
    
    func changed() {
        rac_text.value = self.text ?? ""
    }
    
    public var rac_textColor : MutableProperty<UIColor?> {
        return lazyMutableProperty(self, &AssociationKey.textColor, { [unowned self] in self.textColor = $0 }, { [unowned self] in self.textColor })
    }
}

public protocol Enablable : class {
    var enabled : Bool {get set}
}

extension UIControl : Enablable {}
extension UIBarButtonItem : Enablable {}
extension Enablable {
    public var rac_enabled : MutableProperty<Bool> {
        return lazyMutableProperty(self, &AssociationKey.enabled, { [unowned self] in self.enabled = $0 }, { [unowned self] in self.enabled })
    }
}


public protocol Selectable : class {
    var selected : Bool { get set }
}
extension UIControl : Selectable {}
extension UITableViewCell : Selectable {}
extension UICollectionViewCell : Selectable {}
extension Selectable {
    public var rac_selected: MutableProperty<Bool> {
        return lazyMutableProperty(self, &AssociationKey.selected, { [unowned self] in self.selected = $0 }, { [unowned self] in self.selected })
    }
}


extension UIProgressView {
    public var rac_progress : MutableProperty<Float> {
        return lazyMutableProperty(self, &AssociationKey.progress, { [unowned self] in self.progress = $0 }, { [unowned self] in self.progress })
    }
}

extension UIActivityIndicatorView {
    public var rac_animating: MutableProperty<Bool> {
        return lazyMutableProperty(self, &AssociationKey.animating, { [unowned self] in $0 ? self.startAnimating() : self.stopAnimating() }, { [unowned self] in self.isAnimating() })
    }
}

//extension GMSMarker {
//    public var rac_position: MutableProperty<CLLocationCoordinate2D> {
//        return lazyMutableProperty(self, &AssociationKey.position, { [unowned self] in self.position = $0 }, { [unowned self] in self.position })
//    }
//    
//    public var rac_title: MutableProperty<String> {
//        return lazyMutableProperty(self, &AssociationKey.title, { [unowned self] in self.title = $0 }, { [unowned self] in self.title })
//    }
//}

