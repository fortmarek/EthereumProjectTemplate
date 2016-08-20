//
//  Source/Swinject+AutoRegistration.swift
//  Swinject
//
//  Generated using Swinject AutoRegistration generator.
//


 import Swinject 


private func res<Service>(r: Resolvable) -> Service {
   return r.resolve(Service.self)!
}

private func res<Service, Arg1>(params: (r: Resolvable, Arg1)) -> Service {
   return (params.1 as? Service) ?? params.r.resolve(Service.self)!
}

private func res<Service, Arg1, Arg2>(params: (r: Resolvable, Arg1, Arg2)) -> Service {
   return (params.1 as? Service) ?? (params.2 as? Service) ?? params.r.resolve(Service.self)!
}

private func res<Service, Arg1, Arg2, Arg3>(params: (r: Resolvable, Arg1, Arg2, Arg3)) -> Service {
   return (params.1 as? Service) ?? (params.2 as? Service) ?? (params.3 as? Service) ?? params.r.resolve(Service.self)!
}

private func res<Service, Arg1, Arg2, Arg3, Arg4>(params: (r: Resolvable, Arg1, Arg2, Arg3, Arg4)) -> Service {
   return (params.1 as? Service) ?? (params.2 as? Service) ?? (params.3 as? Service) ?? (params.4 as? Service) ?? params.r.resolve(Service.self)!
}

private func res<Service, Arg1, Arg2, Arg3, Arg4, Arg5>(params: (r: Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5)) -> Service {
   return (params.1 as? Service) ?? (params.2 as? Service) ?? (params.3 as? Service) ?? (params.4 as? Service) ?? (params.5 as? Service) ?? params.r.resolve(Service.self)!
}
extension Container {


func register<Service>(service: Service.Type, name: String? = nil, initializer: () -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { _ in
       initializer()
   } as (Resolvable) -> Service)
}

func register<Service, A>(service: Service.Type, name: String? = nil, initializer: (A) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0))
   } as (Resolvable) -> Service)
}

func register<Service, Arg1>(service: Service.Type, name: String? = nil, initializer: (Arg1) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer($0.1)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B>(service: Service.Type, name: String? = nil, initializer: (A, B) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0), res($0))
   } as (Resolvable) -> Service)
}

func register<Service, A, B, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0), res($0))
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0), res($0))
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C>(service: Service.Type, name: String? = nil, initializer: (A, B, C) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0), res($0), res($0))
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0), res($0), res($0))
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0), res($0), res($0))
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0)
       return initializer(a, b, c)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0), res($0), res($0), res($0))
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0), res($0), res($0), res($0))
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0)
       return initializer(a, b, c, d)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0)
       return initializer(a, b, c, d)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0)
       return initializer(a, b, c, d)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       initializer(res($0), res($0), res($0), res($0), res($0))
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0)
       return initializer(a, b, c, d, e)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0)
       return initializer(a, b, c, d, e)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0)
       return initializer(a, b, c, d, e)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0)
       return initializer(a, b, c, d, e)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0)
       return initializer(a, b, c, d, e)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0)
       return initializer(a, b, c, d, e, f)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0)
       return initializer(a, b, c, d, e, f)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0)
       return initializer(a, b, c, d, e, f)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0)
       return initializer(a, b, c, d, e, f)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0)
       return initializer(a, b, c, d, e, f)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0)
       return initializer(a, b, c, d, e, f)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F, G>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0)
       return initializer(a, b, c, d, e, f, g)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, G, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0)
       return initializer(a, b, c, d, e, f, g)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, G, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0)
       return initializer(a, b, c, d, e, f, g)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, G, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0)
       return initializer(a, b, c, d, e, f, g)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, G, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0)
       return initializer(a, b, c, d, e, f, g)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, G, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0)
       return initializer(a, b, c, d, e, f, g)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0)
       return initializer(a, b, c, d, e, f, g, h)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0)
       return initializer(a, b, c, d, e, f, g, h)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0)
       return initializer(a, b, c, d, e, f, g, h)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0)
       return initializer(a, b, c, d, e, f, g, h)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0)
       return initializer(a, b, c, d, e, f, g, h)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0)
       return initializer(a, b, c, d, e, f, g, h)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0)
       return initializer(a, b, c, d, e, f, g, h, i)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0)
       return initializer(a, b, c, d, e, f, g, h, i)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0)
       return initializer(a, b, c, d, e, f, g, h, i)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0)
       return initializer(a, b, c, d, e, f, g, h, i)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0)
       return initializer(a, b, c, d, e, f, g, h, i)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0)
       return initializer(a, b, c, d, e, f, g, h, i)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> Service) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0); let o: O = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
   } as (Resolvable) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, Arg1>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> Service, argument: (Arg1.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0); let o: O = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
   } as (Resolvable, Arg1) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, Arg1, Arg2>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> Service, arguments: (Arg1.Type, Arg2.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0); let o: O = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
   } as (Resolvable, Arg1, Arg2) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, Arg1, Arg2, Arg3>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0); let o: O = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
   } as (Resolvable, Arg1, Arg2, Arg3) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, Arg1, Arg2, Arg3, Arg4>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0); let o: O = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4) -> Service)
}

func register<Service, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, Arg1, Arg2, Arg3, Arg4, Arg5>(service: Service.Type, name: String? = nil, initializer: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> Service, arguments: (Arg1.Type, Arg2.Type, Arg3.Type, Arg4.Type, Arg5.Type)) -> ServiceEntry<Service> {
   return self.register(service.self, name: name, factory: { 
       let a: A = res($0); let b: B = res($0); let c: C = res($0); let d: D = res($0); let e: E = res($0); let f: F = res($0); let g: G = res($0); let h: H = res($0); let i: I = res($0); let j: J = res($0); let k: K = res($0); let l: L = res($0); let m: M = res($0); let n: N = res($0); let o: O = res($0)
       return initializer(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
   } as (Resolvable, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service)
}


}
