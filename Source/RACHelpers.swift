//
//  File.swift
//  AudioGuide
//
//  Created by Petr Šíma on Sep/17/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa

extension SignalProducerType {
	public func ignoreError() -> SignalProducer<Value, NoError> {
		return flatMapError { _ in SignalProducer.empty }
	}
}

public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
	let producers =  SignalProducer<SignalProducer<T, E>, E>(values: signals)
	return producers.flatten(.Merge)
}
