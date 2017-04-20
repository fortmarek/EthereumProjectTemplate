// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs
// swiftlint:disable type_name

enum L10n {

  enum Basic {
    /// Cancel
    static let cancel = L10n.tr("basic.cancel")
    /// 
    static let error = L10n.tr("basic.error")
    /// Unable to save the user
    static let genericKeychainError = L10n.tr("basic.genericKeychainError")
    /// There was a problem communicating with the server
    static let genericMappingError = L10n.tr("basic.genericMappingError")
    /// OK
    static let ok = L10n.tr("basic.ok")
    /// Show more
    static let showMore = L10n.tr("basic.show_more")
  }

  enum Languagetable {
    /// Close
    static let networkErrorDismiss = L10n.tr("languageTable.network_error_dismiss")
    /// Unable to download list of languages
    static let networkErrorMessage = L10n.tr("languageTable.network_error_message")
    /// Network error
    static let networkErrorTitle = L10n.tr("languageTable.network_error_title")
  }
}

extension L10n {
  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

// swiftlint:enable type_body_length
// swiftlint:enable nesting
// swiftlint:enable variable_name
// swiftlint:enable valid_docs
