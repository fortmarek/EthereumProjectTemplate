//
//  UserManager.swift
//  iLikeYou
//
//  Created by Tomas Kohout on 2/29/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa
import CoreData
import Locksmith

private let keyChainAccount = NSBundle.mainBundle().bundleIdentifier!

enum UserError: ErrorType {
    case Keychain(NSError)
    case Encoding
    case Request(RequestError)
}
extension UserError : ErrorPresentable {
    var message: String {
        switch self {
        case .Keychain(let e): return e.message
        case .Request(let e): return e.message
        case .Encoding: return L10n.GenericKeychainError.string
        }
    }
}


protocol UserManaging {
    var user: MutableProperty<UserEntity?> {get set}
    var credentials: Credentials? {get}
    func logout() -> SignalProducer<(), NoError>
    func isLoggedIn() -> Bool
    func login(username: String, password: String) -> SignalProducer<UserEntity, UserError>
}

class UserManager: UserManaging {
    private let api: AuthenticationAPIServicing
    
    var user = MutableProperty<UserEntity?>(nil)
    
    lazy var credentials: Credentials? = {
        guard let result = Locksmith.loadDataForUserAccount(keyChainAccount) else { return nil }
        
        if let credentials =  Credentials(data: result) {
            return credentials
        } else {
            do {
                //The data is in keychain but we were unable to decode it
                try Locksmith.deleteDataForUserAccount(keyChainAccount)
            } catch {
                return nil
            }
        }
        
        return nil
    }()
    
    init(api: AuthenticationAPIServicing) {
        self.api = api
    }
    
    func saveCredentials(var credentials: Credentials, user: UserEntity) -> SignalProducer<Credentials, UserError> {
        return SignalProducer { sink, disposable in
            do {
                credentials.id = user.id
                
                if let _ = self.credentials {
                    try Locksmith.deleteDataForUserAccount(keyChainAccount)
                }
                
                if let data = credentials.toKeychainData() {
                    try Locksmith.saveData(data, forUserAccount: keyChainAccount)
                    sink.sendNext(credentials)
                    sink.sendCompleted()
                } else {
                    //Unable to encode data to keychain
                    sink.sendFailed(.Encoding)
                }
            } catch let e as NSError {
                sink.sendFailed(.Keychain(e))
            }
        }
    }
    
    private func saveUser(currentUser: UserEntity) -> SignalProducer<UserEntity, UserError> {
        return SignalProducer { sink, disposable in
            self.user.value = currentUser
            sink.sendNext(currentUser)
            sink.sendCompleted()
        }
// Alternatively save to core data
//        rac_save(currentUser, context: self.context).on(
//            next: {user in
//                self.user.value = user
//        })
    }
    
    private func save(currentUser: UserEntity, credentials: Credentials) -> SignalProducer<UserEntity, UserError> {
        let saveCredentials =  self.saveCredentials(credentials, user:currentUser).on(next: {credentials in self.credentials = credentials})
        let saveUser = self.saveUser(currentUser)
        
        return saveCredentials.then(saveUser)
    }
    
    //MARK: Public
    
    func isLoggedIn() -> Bool {
        return self.credentials != nil //&& self.user.value != nil
    }
    
    func logout() -> SignalProducer<(), NoError> {
        return SignalProducer { sink, disposable in
            let _ = try? Locksmith.deleteDataForUserAccount(keyChainAccount)
            self.credentials = nil
            self.user.value = nil
            
            sink.sendNext()
            sink.sendCompleted()
        }
    }
    
    func login(username: String, password: String) -> SignalProducer<UserEntity, UserError> {
        return self.api.login(username, password: password).mapError { .Request($0) }.flatMap(.Latest) { currentUser, credentials in
            return self.save(currentUser, credentials: credentials)
        }
    }
    
 
}
