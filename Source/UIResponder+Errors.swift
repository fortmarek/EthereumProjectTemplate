//
//  UIResponder+Errors.swift
//  Tipsy
//
//  Created by Petr Šíma on Jun/22/15.
//  Copyright © 2015 Petr Sima. All rights reserved.
//

import UIKit

protocol ErrorPresentable {
    var title : String? { get }
    var message : String { get }
}
extension ErrorPresentable {
    var title : String? { return nil }
    var debugString: String {
        return "Error at \(NSDate()), title:\(title), message:\(message), instance: \(self)"
    }
}

extension UIResponder {
    func displayError(e: ErrorPresentable) {
        if (self as? ErrorPresenting)?.presentError(e) == true { //stop
            return
        }else {
            nextResponder()?.displayError(e)
        }
    }
}

protocol ErrorPresenting {
    func presentError(e: ErrorPresentable) -> Bool
}

extension AppDelegate : ErrorPresenting {
    func presentError(e : ErrorPresentable) -> Bool {
        defer {
            logError(e)
        }
        guard let window = UIApplication.sharedApplication().keyWindow else { return false }
        let alertController = UIAlertController(title: e.title ?? "error".localized, message: e.message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .Cancel) { _ in }
        alertController.addAction(okAction)
        
//        if Environment.scheme == .Development || Environment.scheme == .AdHoc { //TODO: dont show more info in release version?
//        #if DEBUG
        let showMoreAction = UIAlertAction(title: "Show More", style: .Default) { _ in
                let detailAlertController = UIAlertController(title: "Error Detail", message: "\(e)", preferredStyle: .Alert)
                let detailOkAction = UIAlertAction(title: "ok".localized, style: .Cancel) { _ in }
                detailAlertController.addAction(detailOkAction)
                window.rootViewController?.frontmostController.presentViewController(detailAlertController, animated: true) { _ in }
            }
            alertController.addAction(showMoreAction)
//        #endif
//        }
        window.rootViewController?.frontmostController.presentViewController(alertController, animated: true) { _ in }
        return true
    }
    
    private func logError(e : ErrorPresentable) {
        print(e.debugString)
        //if you use any console or logger library, call it here...
    }
}
