import Quick
import Nimble
import ReactiveSwift

@testable import ProjectSkeleton

class LanguageTableViewCellSpec: QuickSpec {
    
    class LanguagesDetailViewModelStub : LanguageDetailViewModeling {
        let name = MutableProperty("")
        let sentence = MutableProperty("")
        let flagURL = MutableProperty<URL>(URL(string: "http://example.com")!)
        let isSpeaking = MutableProperty(false)
        
        lazy var playSentence: Action<Void, (), SpeakError> = Action { _ in SignalProducer.empty }

        init() {}
    }
    
    override func spec() {
        describe("Language table view cell"){
            
            it("only binds against its current viewModel") {
                let cell = LanguageTableViewCell(style: .default, reuseIdentifier: "id")
                let vm1 = LanguagesDetailViewModelStub()
                let vm2 = LanguagesDetailViewModelStub()

                cell.viewModel.value = vm1
                cell.viewModel.value = vm2
                vm2.name.value = "vm2" //this happens first
                vm1.name.value = "vm1" //this happens second

                expect(cell.nameLabel.text).toEventually(equal("vm2"))
            }
        }
    }
}
