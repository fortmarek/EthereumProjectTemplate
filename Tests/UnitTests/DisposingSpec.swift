import Quick
import Nimble
import ACKReactiveExtensions
import ReactiveSwift
@testable import ProjectSkeleton

class DisposingSpec: QuickSpec {
    
    class TestDisposingImpl : Disposing { }
    
    override func spec() {
        describe("disposing") {
            it("fires an event on its rac_willDeallocSignal when its dealloced") {
                var disposed = false
                var objectToDealloc : Disposing? = TestDisposingImpl()
                SignalProducer<(),NoError> { _, dis in
                    dis.add {
                        disposed = true
                    }
                }
                    .take(until: objectToDealloc!.rac_lifetime.ended)
                    .start()
                objectToDealloc = nil
                
                expect(disposed).to(beTrue())
            }
        }
    }
}
