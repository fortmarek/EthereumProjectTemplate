import Quick
import Nimble
@testable import SampleTestingProject

class AuthenticatedAPIServiceSpec: QuickSpec {
    class AuthTestAPIService: AuthenticatedAPIService {
    }

    class NetworkStub: Networking {
    }

    override func spec() {
        var api: AuthTestAPIService
        var network: Networking

        beforeEach {
            network = NetworkStub()
            api = AuthTestAPIService()
        }

//        describe("Authenticated APIService") {
//            it(")
//        }

    }
}
