//
//  Credentials.swift
//  Skeleton
//
//  Created by Jakub Olejník on 02/12/2017.
//

import ReactiveSwift

import enum Result.NoError
typealias NoError = Result.NoError

protocol CredentialsProvider: ReactiveExtensionsProvider {
    var credentials: Credentials? { get }
}

struct Credentials {
    let accessToken: String
    let refreshToken: String
}
