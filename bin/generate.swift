#!/usr/bin/env xcrun swift

// Generates a Swift file with implementation of function currying for a ridicolously high number of arguments

import Foundation

let genericServices = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

let genericArgumentPrefix = "Arg"

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

func genericType(for position: Int) -> String {
    let max = genericServices.count
    switch position {
    case _ where position < max: return genericServices[position % max]
    default: return genericServices[position / max - 1] + genericServices[position % max]
    }
}




func commaConcat(xs: [String]) -> String {
    return xs.joinWithSeparator(", ")
}

func registerGenerator(dependenciesCount: Int, argumentsCount: Int) -> String {
    // If there is only one argument and one dependency, it can be checked by compiler
    let isArgumentInjection = dependenciesCount == 1 && argumentsCount == 1
    
    var genericParameters = (0..<dependenciesCount).map(genericType)
    let genericArguments = (1..<(argumentsCount+1)).map{ "\(genericArgumentPrefix)\($0)" }
    var resolvers = commaConcat(genericParameters.map { _ in "res($0)" })
    
    var genericsDefinition = commaConcat(["Service"] + genericParameters + genericArguments)
    
    
    if isArgumentInjection {
        genericParameters = ["\(genericArgumentPrefix)1"]
        genericsDefinition = commaConcat(["Service"] + genericParameters)
        resolvers = "$0.1"
    }
    
    let concatenatedParameters = commaConcat(genericParameters)
    
    
    let argParameterName = argumentsCount == 1 ? "argument" : "arguments"
    let argumentsDefinition = argumentsCount > 0 ? ", \(argParameterName): (\(commaConcat(genericArguments.map{"\($0).Type"})))" : ""
    
    let register = [
        "func register<\(genericsDefinition)>(service: Service.Type, name: String? = nil, initializer: (\(concatenatedParameters)) -> Service\(argumentsDefinition)) -> ServiceEntry<Service> {",
        "   return self.register(service.self, name: name, factory: { \(dependenciesCount == 0 ? "_ in": "")",
        "       initializer(\(resolvers))",
        "   } as (\(commaConcat(["Resolvable"] + genericArguments))) -> Service)",
        "}"
    ]

    return register.joinWithSeparator("\n")
}


func resolverGenerator(arguments: Int) -> String {
    
    
    let genericArguments = (1..<(arguments+1)).map{ "\(genericArgumentPrefix)\($0)" }
    
    let genericsDefinition = commaConcat(["Service"] + genericArguments)
    
    let paramArgs = (1..<(arguments+1)).map { "params.\($0)" }
    
    let argumentsTests = paramArgs.map { "(\($0) as? Service) ?? " }.joinWithSeparator("")
    
    let functionDefinition = arguments == 0 ? "r: Resolvable" : "params: (r:\(commaConcat(["Resolvable"] + genericArguments)))"
    
    let implementation = "return \(argumentsTests)\(arguments == 0 ? "r" : "params.r").resolve(Service.self)!"
    
    let resolver = [
    "private func res<\(genericsDefinition)>(\(functionDefinition)) -> Service{",
    "   \(implementation)",
    "}"
    ]
    return resolver.joinWithSeparator("\n")
}


print("Generating 💬")


let dependenciesCount = Int(Process.arguments[safe: 1] ?? "9")!
let argumentsCount = Int(Process.arguments[safe: 2] ?? "3")!


let resolvers = (0...argumentsCount).map { arg in
    resolverGenerator(arg)
}


let registers = (0...dependenciesCount).map { dep in
    (0...argumentsCount).filter{ dep >= $0 }.map { arg in
        registerGenerator(dep, argumentsCount: arg)
    }
    }.reduce([]){ $0 + $1}

let output = (resolvers + registers).joinWithSeparator("\n\n") + "\n"



print(output)

//let output = curries.joined(separator: "\n\n") + "\n"

let outputPath = "Source/Swinject+AutoRegistration.swift"
//let currentPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
//let currySwiftPath = try! currentPath.appendingPathComponent(outputPath)

//do {
//try output.write(to: currySwiftPath, atomically: true, encoding: String.Encoding.utf8)
//} catch let e as NSError {
//print("An error occurred while saving the generated functions. Error: \(e)")
//}

print("Done, swinject functions files written at \(outputPath) 👍")