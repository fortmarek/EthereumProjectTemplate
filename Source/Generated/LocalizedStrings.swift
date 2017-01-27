// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// Network error
  case languageTableNetworkErrorTitle
  /// Unable to download list of languages
  case languageTableNetworkErrorMessage
  /// Close
  case languageTableNetworkErrorDismiss
  /// There was a problem communicating with the server
  case genericMappingError
  /// Unable to save the user
  case genericKeychainError
}

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .languageTableNetworkErrorTitle:
        return L10n.tr("languageTable.network_error_title")
      case .languageTableNetworkErrorMessage:
        return L10n.tr("languageTable.network_error_message")
      case .languageTableNetworkErrorDismiss:
        return L10n.tr("languageTable.network_error_dismiss")
      case .genericMappingError:
        return L10n.tr("genericMappingError")
      case .genericKeychainError:
        return L10n.tr("genericKeychainError")
    }
  }

  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}
