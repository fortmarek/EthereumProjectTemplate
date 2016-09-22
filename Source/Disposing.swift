//
//  Disposing.swift
//  ProjectSkeleton
//
//  Created by Petr Šíma on 04/02/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa

private struct AssociationKey {
    static var lifecycleObject: UInt8 = 1
}

protocol Disposing : class {
    var rac_willDeallocSignal: Signal<(),NoError> { get }
}

extension NSObject {
    var rac_willDeallocSignal: Signal<(),NoError> {
        var extractedSignal: Signal<(),NoError>!
        self.rac_willDeallocSignal().toSignalProducer().ignoreError().map { _ in () }
            .startWithSignal { signal, _ in
                extractedSignal = signal
        }
        return extractedSignal
    }
}

extension Disposing {
    private var lifecycleObject: NSObject {
        return lazyAssociatedProperty(self, &AssociationKey.lifecycleObject, factory: {
            NSObject()
        })
    }
    
    var rac_willDeallocSignal: Signal<(),NoError> {
        return lifecycleObject.rac_willDeallocSignal
    }
}
