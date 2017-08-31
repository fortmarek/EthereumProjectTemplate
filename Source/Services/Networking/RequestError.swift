//
//  RequestError.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 22/08/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case network(NetworkError)
    case mapping(MappingError)
    case unexpectedEmptyBody
}
extension RequestError: ErrorPresentable {
    var message: String {
        switch self {
        case .network(let e): return e.error.message
        case .mapping, .unexpectedEmptyBody: return L10n.Basic.genericMappingError
        }
    }
}

struct MappingError: ErrorWrapping {
    let underlyingError: Error
}
