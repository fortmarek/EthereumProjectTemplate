// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Unable to save the user
  case GenericKeychainError
  /// There was a problem communicating with the server
  case GenericMappingError
  /// Close
  case LanguageTableNetworkErrorDismiss
  /// Unable to download list of languages
  case LanguageTableNetworkErrorMessage
  /// Network error
  case LanguageTableNetworkErrorTitle
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .GenericKeychainError:
        return L10n.tr("genericKeychainError")
      case .GenericMappingError:
        return L10n.tr("genericMappingError")
      case .LanguageTableNetworkErrorDismiss:
        return L10n.tr("languageTable.network_error_dismiss")
      case .LanguageTableNetworkErrorMessage:
        return L10n.tr("languageTable.network_error_message")
      case .LanguageTableNetworkErrorTitle:
        return L10n.tr("languageTable.network_error_title")
    }
  }

  private static func tr(key: String, _ args: CVarArgType...) -> String {
    let format = NSLocalizedString(key, bundle: NSBundle(forClass: BundleToken.self), comment: "")
    return String(format: format, locale: NSLocale.currentLocale(), arguments: args)
  }
}

func tr(key: L10n) -> String {
  return key.string
}

private final class BundleToken {}
