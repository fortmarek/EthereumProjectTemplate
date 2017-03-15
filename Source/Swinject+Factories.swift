//
//  Swinject+Factories.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/30/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject

public extension Container {
    /**
     Auto-registration of factory equivalent to:
     ```
     self.register(MyFactory.self) {
     {
     r.resolve(MyService.self)!
     }
     }
     ```
     Usage: `autoregisterFactory(MyFactory.self)`
     
     - Parameters:
     - factory: Factory to register
     - Returns: Registered factory service entry
     - Important: Fails on unresolvable service.
     */
    @discardableResult
    public func autoregisterFactory<Service>(factory: (() -> Service).Type) -> ServiceEntry<(() -> Service)> {
        return self.register(factory.self) { r in { arg in
            self.synchronize().resolve(Service.self)!
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
     Usage: `autoregisterFactory(MyFactory.self)`
     
     - Parameters:
     - factory: Factory to register
     - Returns: Registered factory service entry
     - Important: Fails on unresolvable service.
     */
    @discardableResult
    public func autoregisterFactory<Service, Arg1>(factory: ((Arg1) -> Service).Type) -> ServiceEntry<((Arg1) -> Service)> {
        return self.register(factory.self) { r in { arg in
            self.synchronize().resolve(Service.self, argument: arg)!
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
    @discardableResult
    public func autoregisterFactory<Service, Arg1, Arg2>(factory: ((Arg1, Arg2) -> Service).Type) -> ServiceEntry<((Arg1, Arg2) -> Service)> {
        return self.register(factory.self) { r in { arg1, arg2 in
            self.synchronize().resolve(Service.self, arguments: arg1, arg2)!
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
     Usage: `autoregisterFactory(MyFactory.self)`
     
     - Parameters:
     - factory: Factory to register
     - Returns: Registered factory service entry
     - Important: Fails on unresolvable service.
     */
    @discardableResult
    public func autoregisterFactory<Service, Arg1, Arg2, Arg3>(factory: ((Arg1, Arg2, Arg3) -> Service).Type) -> ServiceEntry<((Arg1, Arg2, Arg3) -> Service)> {
        return self.register(factory.self) { r in { arg1, arg2, arg3 in
            self.synchronize().resolve(Service.self, arguments: arg1, arg2, arg3)!
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
     Usage: `autoregisterFactory(MyViewControllerFactory.self, viewModel: ViewModel.self)`
     - Parameters:
     - factory: View controller factory to register
     - viewModel: View model to pass as first argument
     - Returns: Registered view controller factory service entry
     - Important: Fails on unresolvable service.
     */
    @discardableResult
    public func autoregisterFactory<ViewController, ViewModel, Arg1>(factory: ((Arg1) -> ViewController).Type, viewModel: ViewModel.Type) -> ServiceEntry<((Arg1) -> ViewController)> {
        return self.register(factory.self) { r in
            return { arg in
                return self.synchronize().resolve(ViewController.self, argument: r.resolve(ViewModel.self, argument: arg)!)!
            }
        }
    }
}
