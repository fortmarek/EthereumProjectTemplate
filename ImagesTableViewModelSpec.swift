//
//  ImagesTableViewSpec.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/28/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//
import Quick
import Nimble
import ReactiveCocoa

@testable import SampleTestingProject

/// Specificatios of ImageTableViewModel
class ImagesTableViewModelSpec: QuickSpec {
    
    // MARK: Stub
    class GoodStubPixabayApi: API {
        func loadImages(page: Int) -> SignalProducer<[ImageEntity],NSError>{
            return SignalProducer { observer, disposable in
                observer.sendNext(dummyResponse)
                }
                .observeOn(QueueScheduler())
        }
    }
    
    class ErrorStubPixabayApi: API {
        func loadImages(page: Int) -> SignalProducer<[ImageEntity],NSError>{
            return SignalProducer { observer, disposable in
                observer.sendFailed(NSError(domain: "", code: 0, userInfo: nil))
                }
                .observeOn(QueueScheduler())
        }
    }
    
    class StubNetwork: Networking {
        func call<T>(route: APIRouter, authHandler: AuthHandler?, useDisposables: Bool, action: (AnyObject -> (SignalProducer<T, NSError>))) -> SignalProducer<T, NSError> {
            return SignalProducer.empty
        }
    }
    
    
    override func spec() {
        var viewModel: ImagesTableViewModel!
        
        
        beforeEach {
            viewModel = ImagesTableViewModel(api: GoodStubPixabayApi())
        }
        
        describe("Image load") {
            it("eventually sets cellModels after load") {
                var cellModels: [ImagesTableViewCellModeling]? = nil
                viewModel.cellModels.producer
                    .on(next: { cellModels = $0 })
                    .start()
                
                viewModel.loadImages.apply().start()
                
                expect(cellModels).toEventuallyNot(beNil())
                expect(cellModels?.count).toEventually(equal(2))
                expect(cellModels?[0].id).toEventually(equal(10000))
                expect(cellModels?[1].id).toEventually(equal(10001))
                
            }
            
            it("updates loading property ") {
                var observedValues = [Bool]()
                viewModel.loading.producer
                    .on(next: { observedValues.append($0) })
                    .start()
                
                viewModel.loadImages.apply().start()
                
                expect(observedValues).toEventually(equal([false, true, false]))
            }
            
            
            context("on error") {
                it("sets errorMessage property.") {
                    let viewModel = ImagesTableViewModel(api: ErrorStubPixabayApi())
                    viewModel.loadImages.apply().start()
                    expect(viewModel.errorMessage.value).toEventuallyNot(beNil())
                }
            }
        }
    }
}
