import Quick
import Nimble
import ReactiveCocoa
@testable import ProjectSkeleton

class DisposingSpec: QuickSpec {
    
    class TestDisposingImpl : Disposing { }
    
    override func spec() {
        describe("disposing") {
            it("fires an event on its rac_willDeallocSignal when its dealloced") {
                var disposed = false
                var objectToDealloc : Disposing? = TestDisposingImpl()
                SignalProducer<(),NoError> { _, dis in
                    dis.addDisposable {
                        disposed = true
                    }
                }
                    .takeUntil(objectToDealloc!.rac_willDeallocSignal)
                    .start()
                objectToDealloc = nil
                
                expect(disposed).to(beTrue())
            }
        }
    }
}
