//
//  Swinject+Enhancements.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 8/20/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Swinject


infix operator ~ { associativity left precedence 160 }
postfix operator ~ {}

/** Unary operator which automatically resolves the return type
 Usage: `SomeClass(dependencyA: r~, dependencyB: r~)`
 - Parameters:
    - r: Resolver
 - Returns: The resolved service type instance. 
 - Important: Fails on unresolvable service.
 */
postfix func ~ <Service>(r: ResolverType) -> Service {
    return r.resolve(Service.self)!
}

/** Binary operator ~ equivalent to `r.resolve(Service.Type)!`
 
 Usage: `SomeClass(dependencyA: r ~ DependencyA.self)`
 - Parameters:
   - r: Resolver
   - service: Type of service to resolve.

 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
*/
func ~ <Service>(r: ResolverType, service: Service.Type) -> Service {
    return r.resolve(service)!
}

/** Binary operator ~ equivalent to `r.resolve(Service.Type, argument: Arg1)!`
 
 Usage: `SomeClass(dependencyA: r ~ (DependencyA.self, argument: arg))`
 - Parameters:
 - r: Resolver
 - o.service: Type of service to resolve.
 - o.argument: Argument to pass
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
func ~ <Service, Arg1>(r: ResolverType, o: (service: Service.Type, argument: Arg1) ) -> Service {
    return r.resolve(o.service, argument: o.argument)!
}

/** Binary operator ~ equivalent to `r.resolve(Service.Type, arguments: (Arg1, Arg2))!`
 
 Usage: `SomeClass(dependencyA: r ~ (DependencyA.self, arguments: (arg1, arg2)))`
 - Parameters:
 - r: Resolver
 - o.service: Type of service to resolve.
 - o.arguments: Arguments to pass
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
func ~ <Service, Arg1, Arg2>(r: ResolverType, o: (Service.Type, arguments: (Arg1, Arg2)) ) -> Service {
    return r.resolve(o.0, arguments: o.arguments)!
}

extension Container {
    /**
     Auto-registration of factory equivalent to:
     ```
     self.register(MyFactory.self) {
        {
            r.resolve(MyService.self)!
        }
     }
     ```
     Usage: `registerFactory(MyFactory.self)`
     
     - Parameters:
        - factory: Factory to register
     - Returns: Registered factory service entry
     - Important: Fails on unresolvable service.
     */
    func registerFactory<Service>(factory: (() -> Service).Type) -> ServiceEntry<(() -> Service)> {
        return self.register(factory.self) { r in
            { arg in
                r.resolve(Service.self)!
            }
        }
    }
    
    /**
     Auto-registration of factory with one argument equivalent to:
     ```
     self.register(MyFactory.self) { r in
        { arg1 in
            r.resolve(MyService.self, argument: arg1)!
        }
     }
     ```
     Usage: `registerFactory(MyFactory.self)`
     
     - Parameters:
        - factory: Factory to register
     - Returns: Registered factory service entry
     - Important: Fails on unresolvable service.
     */
    
    func registerFactory<Service, Arg1>(factory: ((Arg1) -> Service).Type) -> ServiceEntry<((Arg1) -> Service)> {
        return self.register(factory.self) { r in
            { arg in
                r.resolve(Service.self, argument: arg)!
            }
        }
    }
    
    
    
    /**
     Auto-registration of factory with two arguments equivalent to:
     ```
     self.register(MyFactory.self) { r in
        { arg1, arg2 in
            r.resolve(MyService.self, arguments: (arg1, arg2))!
        }
     }
     ```
     Usage: `registerFactory(MyFactory.self)`
     
     - Parameters:
        - factory: Factory to register
     - Returns: Registered factory service entry
     - Important: Fails on unresolvable service.
     */
    
    func registerFactory<Service, Arg1, Arg2>(factory: ((Arg1, Arg2) -> Service).Type) -> ServiceEntry<((Arg1, Arg2) -> Service)> {
        return self.register(factory.self) { r in
            { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    /**
     Auto-registration of factory with three arguments equivalent to:
     ```
     self.register(MyFactory.self) { r in
        { arg1, arg2, arg3 in
            r.resolve(MyService.self, arguments: (arg1, arg2, arg3))!
        }
     }
     ```
     Usage: `registerFactory(MyFactory.self)`
     
     - Parameters:
        - factory: Factory to register
     - Returns: Registered factory service entry
     - Important: Fails on unresolvable service.
     */
    func registerFactory<Service, Arg1, Arg2, Arg3>(factory: ((Arg1, Arg2, Arg3) -> Service).Type) -> ServiceEntry<((Arg1, Arg2, Arg3) -> Service)> {
        return self.register(factory.self) { r in
            { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    
    /**
     Registration of viewmodel-viewcontroller factory, resolving ViewController and passing ViewModel as the first argument, which ten again accepts argument from the factory. Useful when you need to pass dynamic arguments to viewModel while also creating new view controller. Equivalent to:
     ```
     self.register(MyViewControllerFactory.self) { arg in
        r.resolve(MyViewController.self, argument: r.resolve(MyViewModel.self, argument: arg))!
     }
     ```
     Usage: `registerFactory(MyViewControllerFactory.self, viewModel: ViewModel.self)`
     - Parameters:
        - factory: View controller factory to register
        - viewModel: View model to pass as first argument
     - Returns: Registered view controller factory service entry
     - Important: Fails on unresolvable service.
     */
    func registerFactory<ViewController, ViewModel, Arg1>(factory: ((Arg1) -> ViewController).Type, viewModel: ViewModel.Type) -> ServiceEntry<((Arg1) -> ViewController)> {
        return self.register(factory.self) { r in
            return { arg in
                return r.resolve(ViewController.self, argument: r.resolve(ViewModel.self, argument: arg)!)!
            }
        }
    }
}
