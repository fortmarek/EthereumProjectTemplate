// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit

extension UIImage {
  enum Asset: String {
    case Icon_60 = "Icon-60"
    case Icon_72 = "Icon-72"
    case Icon_Small_50 = "Icon-Small-50"
    case Icon = "Icon"
    case ITunesArtwork = "iTunesArtwork"
    case LockOff = "LockOff"
    case LockOn = "LockOn"

    var image: UIImage {
      return UIImage(asset: self)
    }
  }

  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
