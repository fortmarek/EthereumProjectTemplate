//
//  UIResponder+Errors.swift
//  Tipsy
//
//  Created by Petr Šíma on Jun/22/15.
//  Copyright © 2015 Petr Sima. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol ErrorPresentable {
    var title: String? { get }
    var message: String { get }
}
extension ErrorPresentable {
    var title: String? { return nil }
    var debugString: String {
        return "Error at \(Date()), title:\(title), message:\(message), instance: \(self)"
    }
}
extension NSError: ErrorPresentable {
    var message: String {
        return localizedDescription
    }
}

extension UIResponder {
    func displayError(_ e: ErrorPresentable) {
        if (self as? ErrorPresenting)?.presentError(e) == true { // stop
            return
        } else {
            next?.displayError(e)
        }
    }
}

protocol ErrorPresenting {
    func presentError(_ e: ErrorPresentable) -> Bool
}

extension AppDelegate: ErrorPresenting {
    func presentError(_ e: ErrorPresentable) -> Bool {
        defer {
            logError(e)
        }
        guard let window = UIApplication.shared.keyWindow else { return false }
        let alertController = UIAlertController(title: e.title ?? "error".localized(), message: e.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized(), style: .cancel) { _ in }
        alertController.addAction(okAction)

        #if DEBUG
        let showMoreAction = UIAlertAction(title: "Show More", style: .default) { _ in
            let detailAlertController = UIAlertController(title: "Error Detail", message: "\(e)", preferredStyle: .alert)
            let detailOkAction = UIAlertAction(title: "ok".localized(), style: .cancel) { _ in }
            detailAlertController.addAction(detailOkAction)
            window.rootViewController?.frontmostController.present(detailAlertController, animated: true) { _ in }
        }
        alertController.addAction(showMoreAction)
        #endif

        window.rootViewController?.frontmostController.present(alertController, animated: true) { _ in }
        return true
    }

    fileprivate func logError(_ e: ErrorPresentable) {
        print(e.debugString)
        // if you use any console or logger library, call it here...
    }
}

extension UIResponder {
    func displayErrors<Input, Output, Error: ErrorPresentable>(forAction action: Action < Input, Output, Error>) {
        action.errors
            .take(until: reactive.lifetime.ended)
            .observeValues { [weak self] e in
                self?.displayError(e)
        }
    }
}
