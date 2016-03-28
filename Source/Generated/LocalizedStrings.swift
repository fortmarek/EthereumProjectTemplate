// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// Network error
  case LanguageTableNetworkErrorTitle
  /// Unable to download list of languages
  case LanguageTableNetworkErrorMessage
  /// Close
  case LanguageTableNetworkErrorDismiss
  /// There was a problem communicating with the server
  case GenericMappingError
}

extension L10n : CustomStringConvertible {
  var description : String { return self.string }

  var string : String {
    switch self {
      case .LanguageTableNetworkErrorTitle:
        return L10n.tr("languageTable.network_error_title")
      case .LanguageTableNetworkErrorMessage:
        return L10n.tr("languageTable.network_error_message")
      case .LanguageTableNetworkErrorDismiss:
        return L10n.tr("languageTable.network_error_dismiss")
      case .GenericMappingError:
        return L10n.tr("genericMappingError")
    }
  }

  private static func tr(key: String, _ args: CVarArgType...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, arguments: args)
  }
}

func tr(key: L10n) -> String {
  return key.string
}
