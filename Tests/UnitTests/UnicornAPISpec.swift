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

// Connects to real server a tries to download data
class UnicornAPISpec: QuickSpec {
    override func spec() {
        var api: API!
        var network: Networking!
        
        beforeEach {
            network = Network()
            api = UnicornAPI(network: network)
        }
        
        describe("Unicorn api") {
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
                expect(languages).toEventuallyNot(beNil(), timeout: 10)
                expect(networkError).toEventually(beNil(), timeout: 10)
                
            }
        }
    }
}
