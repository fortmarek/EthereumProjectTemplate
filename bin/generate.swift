#!/usr/bin/env xcrun swift

// Generates a Swift file with implementation of function currying for a ridicolously high number of arguments

import Foundation

let genericServices = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

let genericArgumentPrefix = "Arg"

let outputPath = "Source/Swinject+AutoRegistration.swift"

func headers(fileName: String) -> String {
    return ["//",
    "//  \(fileName)",
    "//  Swinject",
    "//",
    "//  Generated using Swinject AutoRegistration generator.",
    "//"].joinWithSeparator("\n")
}

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

func registerGenerator(dependenciesCount: Int, argumentsCount: Int, breakIntoVariables: Bool = false) -> String {
    // If there is only one argument and one dependency, it can be checked by compiler
    let isArgumentInjection = dependenciesCount == 1 && argumentsCount == 1
    
    var genericParameters = (0..<dependenciesCount).map(genericType)
    let genericArguments = (1..<(argumentsCount+1)).map{ "\(genericArgumentPrefix)\($0)" }
    var resolvers = genericParameters.map { _ in "res($0)" }
    
    var genericsDefinition = commaConcat(["Service"] + genericParameters + genericArguments)
    
    
    if isArgumentInjection {
        genericParameters = ["\(genericArgumentPrefix)1"]
        genericsDefinition = commaConcat(["Service"] + genericParameters)
        resolvers = ["$0.1"]
    }
    
    let concatenatedParameters = commaConcat(genericParameters)
    
    
    let argParameterName = argumentsCount == 1 ? "argument" : "arguments"
    let argumentsDefinition = argumentsCount > 0 ? ", \(argParameterName): (\(commaConcat(genericArguments.map{"\($0).Type"})))" : ""
    
    let initializer: String
    
    if breakIntoVariables {
        let services = genericParameters.enumerate().map { "let \($1.lowercaseString): \($1) = \(resolvers[$0])" }
        initializer = "       " + services.joinWithSeparator("; ") + "\n" +
            "       return initializer(\(commaConcat(genericParameters.map{ $0.lowercaseString })))"
    } else {
        initializer = "       initializer(\(commaConcat(resolvers)))"
    }
    let register = [
        "func register<\(genericsDefinition)>(service: Service.Type, name: String? = nil, initializer: (\(concatenatedParameters)) -> Service\(argumentsDefinition)) -> ServiceEntry<Service> {",
        "   return self.register(service.self, name: name, factory: { \(dependenciesCount == 0 ? "_ in": "")",
        initializer,
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
    
    let functionDefinition = arguments == 0 ? "r: Resolvable" : "params: (r: \(commaConcat(["Resolvable"] + genericArguments)))"
    
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
let breakCount = Int(Process.arguments[safe: 3] ?? "5")!

let resolvers = (0...argumentsCount).map { arg in
    resolverGenerator(arg)
}

let registers = (0...dependenciesCount).map { dep in
    (0...argumentsCount).filter{ dep >= $0 }.map { arg in
        registerGenerator(dep, argumentsCount: arg, breakIntoVariables: dep + arg > breakCount)
    }
    }.reduce([]){ $0 + $1}

var output = [
    headers(outputPath),
    "\n\n import Swinject \n\n",
    resolvers.joinWithSeparator("\n\n"),
    "extension Container {\n\n",
        registers.joinWithSeparator("\n\n"),
    "\n\n}"
].joinWithSeparator("\n")

let currentPath = NSURL(fileURLWithPath: NSFileManager.defaultManager().currentDirectoryPath)
let swinjectPath = currentPath.URLByAppendingPathComponent(outputPath)

do {
    try output.writeToURL(swinjectPath, atomically: true, encoding: NSUTF8StringEncoding)
} catch let e as NSError {
    print("An error occurred while saving the generated functions. Error: \(e)")
}

print("Done, swinject functions files written at \(outputPath) 👍")