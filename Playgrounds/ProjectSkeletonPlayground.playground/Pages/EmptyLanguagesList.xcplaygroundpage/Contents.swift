//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ReactiveSwift
@testable import ProjectSkeletonFramework

class EmptyLanguagesAPIService: LanguagesAPIServicing {
    func languages() -> SignalProducer<[Language], RequestError> {
        return SignalProducer(value: [])
    }
}

//Mock the api service in container
AppContainer.autoregister(LanguagesAPIServicing.self, initializer: EmptyLanguagesAPIService.init)


let controller = AppContainer.resolve(LanguagesTableViewController.self)!
let parent = PlaygroundController(device: .phone4_7inch, orientation: .portrait, scale: 0.75, child: controller)

PlaygroundPage.current.liveView = parent
