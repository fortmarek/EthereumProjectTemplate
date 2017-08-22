//
//  ErrorWrapping.swift
//  ProjectSkeleton
//
//  Created by Petr Šíma on 28/11/2016.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation

// Using Error directly in Swift is problematic - we cannot use it as a type, it isnt strongly typed, cannot be extended. This ErrorWrapping protocol tries to aleviate some of these problems. This hasnt been properly tested and might turn out to be worse than the original state.
protocol ErrorWrapping: Error, ErrorPresentable {
    var underlyingError: Error { get }
}

extension ErrorWrapping {
    var localizedDescription: String { return underlyingError.localizedDescription }
}

extension ErrorWrapping {
    var message: String {
        return (underlyingError as ErrorPresentable).message
    }
}
