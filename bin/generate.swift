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
    
    let argParameterName = argumentsCount == 1 ? "argument" : "arguments"
    
    var genericParameters = (0..<dependenciesCount).map(genericType) // ["A", "B", "C"]
    let genericArguments = (1..<(argumentsCount+1)).map{ "\(genericArgumentPrefix)\($0)" } // ["Arg1", "Arg2", "Arg3"]
    let genericArgumentsVars = genericArguments.map { $0.lowercaseString } // ["arg1", "arg2", "arg3"]
    
    var resolvers = genericParameters.map { _ in "r.resolve(\( argumentsCount > 0 ? "\(argParameterName): (\(commaConcat(genericArgumentsVars)))" : ""))" }
    
    var genericsDefinition = commaConcat(["Service"] + genericParameters + genericArguments)
    
    if isArgumentInjection {
        genericParameters = ["\(genericArgumentPrefix)1"]
        genericsDefinition = commaConcat(["Service"] + genericParameters)
        resolvers = ["\(genericArgumentPrefix.lowercaseString)1"]
    }
    
    let concatenatedParameters = commaConcat(genericParameters)
    
    
    let argumentsDefinition = argumentsCount > 0 ? ", \(argParameterName): (\(commaConcat(genericArguments.map{"\($0).Type"})))" : ""
    
    let initializer: String
    
    if breakIntoVariables {
        let services = genericParameters.enumerate().map { "let \($1.lowercaseString): \($1) = \(resolvers[$0])" }
        initializer = "       " + services.joinWithSeparator("; ") + "\n" +
            "       return initializer(\(commaConcat(genericParameters.map{ $0.lowercaseString })))"
    } else {
        initializer = "       initializer(\(commaConcat(resolvers)))"
    }
    
    let closureParameters = commaConcat(["r"] + genericArgumentsVars)
    
    let register = [
        "func register<\(genericsDefinition)>(initializer initializer: (\(concatenatedParameters)) -> Service, service: Service.Type, name: String? = nil\(argumentsDefinition)) -> ServiceEntry<Service> {",
        "   return self.register(service.self, name: name, factory: { \(closureParameters) in ",
        initializer,
        "   } as (\(commaConcat(["Resolvable"] + genericArguments))) -> Service)",
        "}"
    ]

    return register.joinWithSeparator("\n")
}


func resolverGenerator(arguments: Int) -> String {
    
    let argParameterName = arguments == 1 ? "argument" : "arguments"
    
    let genericArguments = (1..<(arguments+1)).map{ "\(genericArgumentPrefix)\($0)" } // ["Arg1", "Arg2", "Arg3"]
    
    let genericsDefinition = commaConcat(["Service"] + genericArguments)
    
    let paramArgs = (0..<(arguments)).map { arguments == 1 ? argParameterName : "\(argParameterName).\($0)" }
    
    let argumentsTests = paramArgs.map { "(\($0) as? Service) ?? " }.joinWithSeparator("")
    
    let functionDefinition = arguments == 0 ? "" : "\(argParameterName) \(argParameterName): (\(commaConcat(genericArguments)))"
    
    let implementation = "return \(argumentsTests)self.resolve(Service.self\(arguments > 0 ? ", \(argParameterName): \(argParameterName)" : ""))!"
    
    let resolver = [
    "func resolve<\(genericsDefinition)>(\(functionDefinition)) -> Service{",
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
    "extension Resolvable {\n\n",
    resolvers.joinWithSeparator("\n\n"),
    "}\n\n",
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