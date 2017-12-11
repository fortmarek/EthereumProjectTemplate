import UIKit
import ACKategories

protocol TextStyling: class {
    var ack_font: UIFont! { get set }
    var ack_textColor: UIColor! { get set }
}

extension TextStyling {
    func style(_ font: UIFont, color: UIColor? = nil) {
        ack_font = font
        ack_textColor =? color
    }
}

extension UILabel: TextStyling {
    var ack_font: UIFont! { get { return font } set { font = newValue } }
    var ack_textColor: UIColor! { get { return textColor } set { textColor = newValue } }
}

extension UITextView: TextStyling {
    var ack_font: UIFont! { get { return font } set { font = newValue } }
    var ack_textColor: UIColor! { get { return textColor } set { textColor = newValue } }
}

extension UITextField: TextStyling {
    var ack_font: UIFont! { get { return font } set { font = newValue } }
    var ack_textColor: UIColor! { get { return textColor } set { textColor = newValue } }
}
