//
//  Swinject+Enhancements.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 8/20/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Swinject


// Operator ~ equivalent to r.resolve(...)!
infix operator ~ { associativity left precedence 160 }
func ~ <Service>(r: ResolverType, o: Service.Type) -> Service {
    return r.resolve(o)!
}

func ~ <Service, Arg1>(r: ResolverType, o: (Service.Type, argument: Arg1) ) -> Service {
    return r.resolve(o.0, argument: o.argument)!
}

func ~ <Service, Arg1, Arg2>(r: ResolverType, o: (Service.Type, arguments: (Arg1, Arg2)) ) -> Service {
    return r.resolve(o.0, arguments: o.arguments)!
}

//private func res<Service>(r: Resolvable) -> Service {
//    let s = r.resolve(Service.self)
//    if let resolved = s {
//        return resolved
//    } else {
//        assertionFailure("Failed to resolve \(Service.self)")
//        return s!
//    }
//}


extension Container {
    //MARK: Factory
    
    func registerFactory<Service>(factory: (() -> Service).Type) -> ServiceEntry<(() -> Service)> {
        return self.register(factory.self) { r in
            return { arg in
                r.resolve(Service.self)!
            }
        }
    }
    
    func registerFactory<Service, Arg1>(factory: ((Arg1) -> Service).Type) -> ServiceEntry<((Arg1) -> Service)> {
        return self.register(factory.self) { r in
            return { arg in
                r.resolve(Service.self, argument: arg)!
            }
        }
    }
    
    func registerFactory<Service, Arg1, Arg2>(factory: ((Arg1, Arg2) -> Service).Type) -> ServiceEntry<((Arg1, Arg2) -> Service)> {
        return self.register(factory.self) { r in
            return { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    func registerFactory<Service, Arg1, Arg2, Arg3>(factory: ((Arg1, Arg2, Arg3) -> Service).Type) -> ServiceEntry<((Arg1, Arg2, Arg3) -> Service)> {
        return self.register(factory.self) { r in
            return { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    func registerFactory<Service, Arg1, Arg2, Arg3, Arg4>(factory: ((Arg1, Arg2, Arg3, Arg4) -> Service).Type) -> ServiceEntry<((Arg1, Arg2, Arg3, Arg4) -> Service)> {
        return self.register(factory.self) { r in
            return { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    func registerFactory<Service, Arg1, Arg2, Arg3, Arg4, Arg5>(factory: ((Arg1, Arg2, Arg3, Arg4, Arg5) -> Service).Type) -> ServiceEntry<((Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)> {
        return self.register(factory.self) { r in
            return { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    func registerFactory<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(factory: ((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) -> Service).Type) -> ServiceEntry<((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) -> Service)> {
        return self.register(factory.self) { r in
            return { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    func registerFactory<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(factory: ((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7) -> Service).Type) -> ServiceEntry<((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7) -> Service)> {
        return self.register(factory.self) { r in
            return { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    func registerFactory<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(factory: ((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8) -> Service).Type) -> ServiceEntry<((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8) -> Service)> {
        return self.register(factory.self) { r in
            return { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    func registerFactory<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(factory: ((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9) -> Service).Type) -> ServiceEntry<((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9) -> Service)> {
        return self.register(factory.self) { r in
            return { args in
                r.resolve(Service.self, arguments: args)!
            }
        }
    }
    
    //MARK: Two level ViewController with ViewModel Factory
    func registerFactory<ViewController, ViewModel, Arg1>(factory: ((Arg1) -> ViewController).Type, viewModel: ViewModel.Type) -> ServiceEntry<((Arg1) -> ViewController)> {
        return self.register(factory.self) { r in
            return { arg in
                return r.resolve(ViewController.self, argument: r.resolve(ViewModel.self, argument: arg)!)!
            }
        }
    }
}
