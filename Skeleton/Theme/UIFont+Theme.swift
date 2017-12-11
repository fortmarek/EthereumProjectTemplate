import UIKit

extension UIFont: ThemeProvider { }

private protocol FontStyle {
    static func regular(_ size: CGFloat) -> UIFont
    static func bold(_ size: CGFloat) -> UIFont
}

extension Theme where Base: UIFont {
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }

    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}

// just an example
//extension UIFont { // if you want to use short dot syntax, it should be just a shortcut to Theme namespace
//    static func mainRegular(_ size: CGFloat) -> UIFont { return UIFont.theme.regular(size) }
//}
