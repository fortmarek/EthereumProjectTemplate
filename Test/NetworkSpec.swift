//
//  NetworkSpec.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/22/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import Quick
import Nimble
@testable import SampleTestingProject

/// Specificatios of Network.
/// As a stable network service, https://httpbin.org is used.
/// Refer to the website for its API details.
class NetworkSpec: QuickSpec {
    override func spec() {
        var api: API!
        var network: Networking!
        
        beforeEach {
            network = Network()
            api = UnicornAPI(network: network)
        }
        

        
        describe("Unicron api") {
            it("eventually load language entities") {
                var languages: [LanguageEntity]?
                var networkError: NSError?;
                
                api.languages()
                    .on(
                        next: { data in
                            languages = data
                        },
                        failed:{ error in
                            networkError = error
                    })
                    .start()
                
                expect(languages).toEventuallyNot(beNil(), timeout: 5)
                expect(networkError).toEventually(beNil(), timeout: 5)
                
            }
            
            
            /*it("eventually gets an error if the network has a problem.") {
                //var error: NetworkError? = nil
                api.requestJSON("https://not.existing.server.comm/get", parameters: ["a": "b", "x": "y"])
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error).toEventually(equal(NetworkError.NotReachedServer), timeout: 5)
            }*/
        }
        /*describe("Image") {
            it("eventually gets an image.") {
                var image: UIImage?
                network.requestImage("https://httpbin.org/image/jpeg")
                    .on(next: { image = $0 })
                    .start()
                
                expect(image).toEventuallyNot(beNil(), timeout: 5)
            }
            it("eventually gets an error if incorrect data for an image is returned.") {
                var error: NetworkError?
                network.requestImage("https://httpbin.org/get")
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error).toEventually(equal(NetworkError.IncorrectDataReturned), timeout: 5)
            }
            it("eventually gets an error if the network has a problem.") {
                var error: NetworkError? = nil
                network.requestImage("https://not.existing.server.comm/image/jpeg")
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error).toEventually(equal(NetworkError.NotReachedServer), timeout: 5)
            }
        }*/
    }
}
