//
//  Router.swift
//  ProjectSkeleton
//
//  Created by Dominik Vesely on 14/12/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import UIKit
import Swinject

public protocol RoutingProvider: class {}

extension RoutingProvider {
    public var router: Router<Self> {
        return Router(self)
    }
}

extension UIViewController : RoutingProvider {}


public struct Router<Base> {
    public let base: Base
    private let container : Container
    
    
    fileprivate init(_ base: Base) {
        self.base = base
        //Jedina čunina pico
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.container = delegate.assembler.resolver as! Container
    }
    
    
    //Destinations to Controllers
    func prepare<VC>(vc: VC.Type) -> VC where VC : UIViewController {
        return container.resolve(vc)!
    }
    
    func prepare<VC, Arg1>(vc: VC.Type, argument: Arg1) -> VC where VC : UIViewController {
        return container.resolve(vc, argument: argument)!
    }
    
    func prepare<VC, Arg1, Arg2>(vc: VC.Type, arguments arg1: Arg1, _ arg2: Arg2) -> VC where VC : UIViewController {
        return container.resolve(vc, arguments: arg1, arg2)!
    }
    
    func prepare<VC, Arg1, Arg2, Arg3>(vc: VC.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3 : Arg3) -> VC where VC : UIViewController {
        return container.resolve(vc, arguments: arg1, arg2, arg3)!
    }
    
    
    //Destination to Factories
    func prepare<VC>(factoryType: (()->VC).Type) -> VC where VC : UIViewController {
        let factory = container.resolve(factoryType)!
        return factory()
    }
    
    func prepare<VC, Arg1>(factoryType: ((Arg1)->VC).Type, argument: Arg1) -> VC where VC : UIViewController {
        let factory = container.resolve(factoryType)!
        return factory(argument)
    }
    
    func prepare<VC, Arg1, Arg2>(factoryType: ((Arg1,Arg2)->VC).Type, arguments arg: Arg1, _ arg2 : Arg2) -> VC where VC : UIViewController {
        let factory = container.resolve(factoryType)!
        return factory(arg,arg2)
    }
    
    func prepare<VC, Arg1, Arg2, Arg3>(factoryType: ((Arg1,Arg2,Arg3)->VC).Type, arguments arg: Arg1, _ arg2 : Arg2, _ arg3: Arg3) -> VC where VC : UIViewController {
        let factory = container.resolve(factoryType)!
        return factory(arg,arg2,arg3)
    }
}


/* Example Extension
 extension Router where Base : AdDetailViewController {
 
 func myFuckingSpecialRoute() -> UIViewController {
 let vm = self.base.viewModel
 return destination(vc: UIViewController.self)
 }
 
 }*/
