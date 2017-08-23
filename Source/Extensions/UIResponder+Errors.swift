//
//  UIResponder+Errors.swift
//  Tipsy
//
//  Created by Petr Šíma on Jun/22/15.
//  Copyright © 2015 Petr Sima. All rights reserved.
//

import UIKit
import ReactiveSwift
import ACKReactiveExtensions

public protocol ErrorPresentable {
    var title: String? { get }
    var message: String { get }
}
public extension ErrorPresentable {
    var title: String? { return nil }
    var debugString: String {
        return "Error at \(Date()), title:\(String(describing: title)), message:\(message), instance: \(self)"
    }
}
extension NSError: ErrorPresentable {
    public var message: String {
        return localizedDescription
    }
}

public extension UIResponder {
    func displayError(_ e: ErrorPresentable) {
        if (self as? ErrorPresenting)?.presentError(e) == true { // stop
            return
        } else {
            next?.displayError(e)
        }
    }
}

public protocol ErrorPresenting {
    func presentError(_ e: ErrorPresentable) -> Bool
}

extension UIWindow: ErrorPresenting {
    public func presentError(_ e: ErrorPresentable) -> Bool {
        defer {
            logError(e)
        }
        guard let window = UIApplication.shared.keyWindow else { return false }
        let alertController = UIAlertController(title: e.title ?? L10n.Basic.error, message: e.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.Basic.ok, style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        #if DEBUG
            let showMoreAction = UIAlertAction(title: L10n.Basic.showMore, style: .default) { _ in
                let detailAlertController = UIAlertController(title: "Error Detail", message: "\(e)", preferredStyle: .alert)
                let detailOkAction = UIAlertAction(title: L10n.Basic.ok, style: .cancel) { _ in }
                detailAlertController.addAction(detailOkAction)
                window.rootViewController?.frontmostController.present(detailAlertController, animated: true, completion: nil)
            }
            alertController.addAction(showMoreAction)
        #endif
        
        window.rootViewController?.frontmostController.present(alertController, animated: true, completion: nil)
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
            .take(during: reactive.lifetime)
            .observeValues { [weak self] e in
                self?.displayError(e)
        }
    }
}

extension Reactive where Base:UIResponder {
    func errors<Error>() -> BindingTarget<Error> where Error: ErrorPresentable {
        return makeBindingTarget { (base, value) in
            base.displayError(value)
        }
    }
}
