//
//  Fetcher.swift
//  VersionUpdateHandler
//
//  Created by Lukáš Hromadník on 19.06.17.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

public protocol Fetcher {
    var version: Int? { get }
    
    func fetch(completion: @escaping () -> Void)
}
