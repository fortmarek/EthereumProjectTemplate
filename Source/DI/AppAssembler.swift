//
//  AppAssembler.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 31/03/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation
import Swinject

//DO NOT call this directly from your code

public let (AppAssembler, AppContainer) = {
    let container = Container()
    
    //Register all assemblies in here
    let assembler = try! Assembler(assemblies: [
        AppAssembly()
        ], container: container)
    
    return (assembler, container)
}() as (Assembler, Container)

