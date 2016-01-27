//
//  ArgoExtensions.swift
//  Pixm8
//
//  Created by Jakub Olejník on 01/12/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Argo

struct ArgoErrors {
    static let domain = "ArgoErrorDomain"
    static let missingKeyErrorKey = "ArgoMissingKey"
    static let typeMismatchErrorActualKey = "ArgoTypeMismatchActual"
    static let typeMismatchErrorExpectedKey = "ArgoTypeMismatchExpected"
    static let customErrorExpectedKey = "ArgoCustomError"
}

extension DecodeError { //Argo errors
    var errorCode : Int {
        switch self {
        case .MissingKey(_): return 1404
        case .TypeMismatch(_): return 1400
        default: return 0
        }
    }
}

public func rac_decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<T,NSError> {
    return SignalProducer { sink, disposable in
        
        let decoded : Decoded<T> = decode(object)
        switch decoded {
        case .Success(let box):
            sink.sendNext(box)
            sink.sendCompleted()
        case .Failure(let e):
            sink.sendFailed(handleError(e))
        }
    }
}



public func rac_decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<[T], NSError>  {
    return SignalProducer { sink, disposable in
        
        let decoded : Decoded<[T]> = decode(object)
        switch decoded {
        case .Success(let box):
            sink.sendNext(box)
            sink.sendCompleted()
            break
        case .Failure(let e):
            sink.sendFailed(handleError(e))
        }
    }
    
}

public func rac_decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey:String, object: AnyObject) -> SignalProducer<[T], NSError>  {
    return SignalProducer { sink, disposable in
        
        let decoded : Decoded<[T]> = decodeWithRootKey(rootKey, object)
        switch decoded {
        case .Success(let box):
            sink.sendNext(box)
            sink.sendCompleted()
            break
        case .Failure(let e):
            sink.sendFailed(handleError(e))
        }
    }
    
}

public func rac_decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey:String, object: AnyObject) -> SignalProducer<T,NSError> {
    return SignalProducer { sink, disposable in
        
        let decoded : Decoded<T> = decodeWithRootKey(rootKey, object)
        switch decoded {
        case .Success(let box):
            sink.sendNext(box)
            sink.sendCompleted()
        case .Failure(let e):
            sink.sendFailed(handleError(e))
        }
    }
}

public func rac_decodeByOne<T: Decodable where T == T.DecodedType>(object: AnyObject) -> SignalProducer<T, NSError>  {
    return SignalProducer { sink, disposable in
        
        let decoded : Decoded<[T]> = decode(object)
        switch decoded {
        case .Success(let box):
            for value in box {
                sink.sendNext(value)
            }
            sink.sendCompleted()
        case .Failure(let e):
            sink.sendFailed(handleError(e))
            break;
        }
        
    }
}

func handleError(e:DecodeError)->NSError{
    
    switch e {
    case .MissingKey(let k):
        let error = NSError(domain: ArgoErrors.domain, code: e.errorCode, userInfo: [ArgoErrors.missingKeyErrorKey : k])
        return error
    case .TypeMismatch(let expected, let actual):
        let error = NSError(domain: ArgoErrors.domain, code: e.errorCode, userInfo: [ArgoErrors.typeMismatchErrorActualKey : expected, ArgoErrors.typeMismatchErrorExpectedKey : actual])
        return error
    case .Custom(let str):
        let error = NSError(domain: ArgoErrors.domain, code: e.errorCode, userInfo: [ArgoErrors.customErrorExpectedKey : str])
        return error
    }
    
}

extension NSURL : Decodable {
    public static func decode(json: JSON) -> Decoded<NSURL> {
        switch json {
        case .String(let s):
            if let url = NSURL(string: s) {
                return .Success(url)
            } else if let url = NSURL(string: s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!) {
                return .Success(url)
            }
            
            return .Failure(DecodeError.Custom("Not a valid URL."))
        default:
            return .Failure(DecodeError.TypeMismatch(expected: "String", actual: json.description))
        }
    }
}