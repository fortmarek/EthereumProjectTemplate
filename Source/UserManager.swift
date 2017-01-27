//
//  UserManager.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 2/29/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreData
import Locksmith

private let keyChainAccount = Bundle.main.bundleIdentifier!

enum UserError: Error {
    case keychain(NSError)
    case encoding
    case request(RequestError)
}
extension UserError: ErrorPresentable {
    var message: String {
        switch self {
        case .keychain(let e): return e.message
        case .request(let e): return e.message
        case .encoding: return L10n.genericKeychainError.string
        }
    }
}

protocol UserManaging {
    var user: MutableProperty<UserEntity?> { get set }
    var credentials: Credentials? { get }
    func logout() -> SignalProducer<(), NoError>
    func isLoggedIn() -> Bool
    func login(_ username: String, password: String) -> SignalProducer<UserEntity, UserError>
}

class UserManager: UserManaging {
    fileprivate let api: AuthenticationAPIServicing

    var user = MutableProperty<UserEntity?>(nil)

    lazy var credentials: Credentials? = {
        guard let result = Locksmith.loadDataForUserAccount(userAccount: keyChainAccount) else { return nil }

        if let credentials = Credentials(data: result) {
            return credentials
        } else {
            do {
                // The data is in keychain but we were unable to decode it
                try Locksmith.deleteDataForUserAccount(userAccount: keyChainAccount)
            } catch {
                return nil
            }
        }

        return nil
    }()

    init(api: AuthenticationAPIServicing) {
        self.api = api
    }

    func saveCredentials(_ credentials: Credentials, user: UserEntity) -> SignalProducer<Credentials, UserError> {
        var credentials = credentials
        return SignalProducer { sink, disposable in
            do {
                credentials.id = user.id

                if let _ = self.credentials {
                    try Locksmith.deleteDataForUserAccount(userAccount: keyChainAccount)
                }

                if let data = credentials.toKeychainData() {
                    try Locksmith.saveData(data: data, forUserAccount: keyChainAccount)
                    sink.send(value: credentials)
                    sink.sendCompleted()
                } else {
                    // Unable to encode data to keychain
                    sink.send(error: .encoding)
                }
            } catch let e as NSError {
                sink.send(error: .keychain(e))
            }
        }
    }

    fileprivate func saveUser(_ currentUser: UserEntity) -> SignalProducer<UserEntity, UserError> {
        return SignalProducer { sink, disposable in
            self.user.value = currentUser
            sink.send(value: currentUser)
            sink.sendCompleted()
        }
// Alternatively save to core data
//        rac_save(currentUser, context: self.context).on(
//            next: {user in
//                self.user.value = user
//        })
    }

    fileprivate func save(_ currentUser: UserEntity, credentials: Credentials) -> SignalProducer<UserEntity, UserError> {
        let saveCredentials = self.saveCredentials(credentials, user: currentUser).on(value: { credentials in self.credentials = credentials })
        let saveUser = self.saveUser(currentUser)

        return saveCredentials.then(saveUser)
    }

    // MARK: Public

    func isLoggedIn() -> Bool {
        return self.credentials != nil // && self.user.value != nil
    }

    func logout() -> SignalProducer<(), NoError> {
        return SignalProducer { sink, disposable in
            let _ = try? Locksmith.deleteDataForUserAccount(userAccount: keyChainAccount)
            self.credentials = nil
            self.user.value = nil

            sink.send(value: ())
            sink.sendCompleted()
        }
    }

    func login(_ username: String, password: String) -> SignalProducer<UserEntity, UserError> {
        return self.api.login(username, password: password).mapError { .request($0) }.flatMap(.latest) { currentUser, credentials in
            return self.save(currentUser, credentials: credentials)
        }
    }

}
