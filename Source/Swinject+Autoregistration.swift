//
//  Swinject+Autoregistration.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 8/6/16.
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

extension Container {
    
    func register<Service>(service: Service.Type, name: String? = nil, initializer:() -> Service) -> ServiceEntry<Service> {
        return self.register(service.self, name: name, factory: { (r) -> Service in
            initializer()
        })
    }
    
    func register<Service, A>(service: Service.Type, name: String? = nil, initializer: (A) -> Service) -> ServiceEntry<Service> {
        return self.register(service.self, name: name) { (r) -> Service in
            return initializer(r.resolve(A.self)!)
        }
    }
    
    func register<Service, A, B>(service: Service.Type, name: String? = nil, initializer: (A, B) -> Service) -> ServiceEntry<Service> {
        return self.register(service.self, name: name) { (r) -> Service in
            return initializer(r.resolve(A.self)!, r.resolve(B.self)!)
        }
    }
    
    func register<Service, A, B, C>(service: Service.Type, name: String? = nil, initializer: (A, B, C) -> Service) -> ServiceEntry<Service> {
        return self.register(service.self, name: name) { (r) -> Service in
            initializer(r.resolve(A.self)!, r.resolve(B.self)!, r.resolve(C.self)!)
        }
    }
    
    func register<Service, A, B, C, D>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D) -> Service) -> ServiceEntry<Service> {
        return self.register(service.self, name: name) { (r) -> Service in
            initializer(r.resolve(A.self)!, r.resolve(B.self)!, r.resolve(C.self)!, r.resolve(D.self)!)
        }
    }
    
    func register<Service, A, B, C, D, E>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E) -> Service) -> ServiceEntry<Service> {
        return self.register(service.self, name: name) { (r) -> Service in
            initializer(r.resolve(A.self)!, r.resolve(B.self)!, r.resolve(C.self)!, r.resolve(D.self)!, r.resolve(E.self)!)
        }
    }
    
    func register<Service, A, B, C, D, E, F>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F) -> Service) -> ServiceEntry<Service> {
        return self.register(service.self, name: name) { (r) -> Service in
            initializer(r.resolve(A.self)!, r.resolve(B.self)!, r.resolve(C.self)!, r.resolve(D.self)!, r.resolve(E.self)!, r.resolve(F.self)!)
        }
    }
    
    func register<Service, A, B, C, D, E, F, G>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G) -> Service) -> ServiceEntry<Service> {
        return self.register(service.self, name: name) { (r) -> Service in
            initializer(r.resolve(A.self)!, r.resolve(B.self)!, r.resolve(C.self)!, r.resolve(D.self)!, r.resolve(E.self)!, r.resolve(F.self)!, r.resolve(G.self)!)
        }
    }
    
    func register<Service, A, B, C, D, E, F, G, H>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H) -> Service) -> ServiceEntry<Service> {
        return self.register(service.self, name: name) { (r) -> Service in
            initializer(r.resolve(A.self)!, r.resolve(B.self)!, r.resolve(C.self)!, r.resolve(D.self)!, r.resolve(E.self)!, r.resolve(F.self)!, r.resolve(G.self)!, r.resolve(H.self)!)
        }
    }
    
    //MARK: With arguments
    
    func register<Service, A, Arg1>(service: Service.Type, name: String? = nil, initializer: (A) -> Service, argument: Arg1.Type) -> ServiceEntry<Service> {
        return self.register(service.self, factory: { (r, arg) -> Service in
            initializer((arg as? A).flatMap { $0 } ?? r.resolve(A.self)!)
            } as (Resolvable, Arg1) -> Service )
    }
    
    func register<Service, A, B, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B) -> Service, argument: Arg1.Type) -> ServiceEntry<Service> {
        return self.register(service.self, name: name, factory: { (r, arg) -> Service in
            initializer((arg as? A).flatMap { $0 } ?? r.resolve(A.self)!, (arg as? B).flatMap { $0 } ?? r.resolve(B.self)!)
            } as (Resolvable, Arg1) -> Service )
    }
    
    func register<Service, A, B, C, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C) -> Service, argument: Arg1.Type) -> ServiceEntry<Service> {
        print(Arg1.self)
        return self.register(service.self, name: name, factory: { (r, arg) -> Service in
            initializer((arg as? A).flatMap { $0 } ?? r.resolve(A.self)!, (arg as? B).flatMap { $0 } ?? r.resolve(B.self)!, (arg as? C).flatMap { $0 } ?? r.resolve(C.self)!)
            } as (Resolvable, Arg1) -> Service )
    }
    
    func register<Service, A, B, C, D, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D) -> Service, argument: Arg1.Type) -> ServiceEntry<Service> {
        return self.register(service.self, name: name, factory: { (r, arg) -> Service in
            initializer((arg as? A).flatMap { $0 } ?? r.resolve(A.self)!, (arg as? B).flatMap { $0 } ?? r.resolve(B.self)!, (arg as? C).flatMap { $0 } ?? r.resolve(C.self)!, (arg as? D).flatMap { $0 } ?? r.resolve(D.self)!)
            } as (Resolvable, Arg1) -> Service )
    }
    
    func register<Service, A, B, C, D, E, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E) -> Service, argument: Arg1.Type) -> ServiceEntry<Service> {
        return self.register(service.self, name: name, factory: { (r, arg) -> Service in
            return initializer((arg as? A).flatMap { $0 } ?? r.resolve(A.self)!, (arg as? B).flatMap { $0 } ?? r.resolve(B.self)!, (arg as? C).flatMap { $0 } ?? r.resolve(C.self)!, (arg as? D).flatMap { $0 } ?? r.resolve(D.self)!, (arg as? E).flatMap { $0 } ?? r.resolve(E.self)!)
            } as (Resolvable, Arg1) -> Service )
    }
    
    func register<Service, A, B, C, D, E, F, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F) -> Service, argument: Arg1.Type) -> ServiceEntry<Service> {
        return self.register(service.self, name: name, factory: { (r, arg) -> Service in
            initializer((arg as? A).flatMap { $0 } ?? r.resolve(A.self)!, (arg as? B).flatMap { $0 } ?? r.resolve(B.self)!, (arg as? C).flatMap { $0 } ?? r.resolve(C.self)!, (arg as? D).flatMap { $0 } ?? r.resolve(D.self)!, (arg as? E).flatMap { $0 } ?? r.resolve(E.self)!, (arg as? F).flatMap { $0 } ?? r.resolve(F.self)!)
            } as (Resolvable, Arg1) -> Service )
    }
    
    func register<Service, A, B, C, D, E, F, G, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G) -> Service, argument: Arg1.Type) -> ServiceEntry<Service> {
        return self.register(service.self, name: name, factory: { (r, arg) -> Service in
            initializer((arg as? A).flatMap { $0 } ?? r.resolve(A.self)!, (arg as? B).flatMap { $0 } ?? r.resolve(B.self)!, (arg as? C).flatMap { $0 } ?? r.resolve(C.self)!, (arg as? D).flatMap { $0 } ?? r.resolve(D.self)!, (arg as? E).flatMap { $0 } ?? r.resolve(E.self)!, (arg as? F).flatMap { $0 } ?? r.resolve(F.self)!, (arg as? G).flatMap { $0 } ?? r.resolve(G.self)!)
            } as (Resolvable, Arg1) -> Service )
    }
    
    func register<Service, A, B, C, D, E, F, G, H, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H) -> Service, argument: Arg1.Type) -> ServiceEntry<Service> {
        return self.register(service.self, name: name, factory: { (r, arg) -> Service in
            initializer((arg as? A).flatMap { $0 } ?? r.resolve(A.self)!, (arg as? B).flatMap { $0 } ?? r.resolve(B.self)!, (arg as? C).flatMap { $0 } ?? r.resolve(C.self)!, (arg as? D).flatMap { $0 } ?? r.resolve(D.self)!, (arg as? E).flatMap { $0 } ?? r.resolve(E.self)!, (arg as? F).flatMap { $0 } ?? r.resolve(F.self)!, (arg as? G).flatMap { $0 } ?? r.resolve(G.self)!, (arg as? H).flatMap { $0 } ?? r.resolve(H.self)!)
            } as (Resolvable, Arg1) -> Service )
    }
    
    
    
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
    //
    //    func registerFactoryTwoLevel<Service, Arg1, A, B, C, D>(factory: ((Arg1) -> Service).Type, initializer:(A, B, C)->D) -> ServiceEntry<((Arg1) -> Service)>{
    //        return self.register(factory.self) { r in
    //            return { arg in
    //
    //                return initializer(r.resolve(A.self, argument: arg)!, r.resolve(B.self)!, r.resolve(C.self)!) as! Service
    //
    //                //return r.resolve(ServiceA.self, argument: r.resolve(ServiceB.self, argument: arg)!)!
    //            }
    //        }
    //    }
    
    
    
    
}
