//
//  Credentials.swift
//  Skeleton
//
//  Created by Jakub Olejník on 02/12/2017.
//

import Foundation

protocol CredentialsProvider {
    var credentials: Credentials? { get }
}

struct Credentials {
    let accessToken: String
    let refreshToken: String
}
