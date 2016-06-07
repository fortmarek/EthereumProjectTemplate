import Quick
import Nimble
import ReactiveCocoa
import Alamofire
@testable import SampleTestingProject

class AuthenticatedAPIServiceSpec: QuickSpec {
    class AuthTestAPIService: AuthenticatedAPIService {
        func testRequest() -> SignalProducer<String, RequestError> {
            return request("", method: .GET, parameters: nil, encoding: .URL, headers: [:])
                .map { $0 as! String }
                .mapError { .Network($0) }
        }
    }

    class NetworkStub: Networking {
        var expectedToken: String = "firstToken"

        func request(url: String, method: Alamofire.Method, parameters: [String: AnyObject]?, encoding: ParameterEncoding, headers: [String: String]?, useDisposables: Bool) -> SignalProducer<AnyObject, NetworkError> {
            return SignalProducer { [unowned self] sink, dis in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    sleep(2)
                    switch headers?["Authorization"] {
                    case .Some(let token) where token.stringByReplacingOccurrencesOfString("Dummytokentype ", withString: "", options: NSStringCompareOptions()) == self.expectedToken: sink.sendNext("dummyResult"); sink.sendCompleted()
                    default: // didnt get correct token, return 401
                        let theUrl = NSURL(string: url)!
                        let originalRequest = NSMutableURLRequest(URL: theUrl) // mimic alamofire behaviour
                        originalRequest.allHTTPHeaderFields = headers
                        let response = NSHTTPURLResponse(URL: theUrl, statusCode: 401, HTTPVersion: nil, headerFields: nil)
                        sink.sendFailed(NetworkError(error: NSError(domain: "ctyristajednicka", code: 0, userInfo: nil), request: originalRequest, response: response))
                    }

                }
            }
        }

    }

    class UserManagerStub: UserManaging {
        var user: MutableProperty<UserEntity?> = MutableProperty(nil)
        var credentials: Credentials? = Credentials(access_token: "firstToken", expires_in: 0, token_type: "dummyTokenType", scope: "", refresh_token: "")
        func logout() -> SignalProducer<(), NoError> { return SignalProducer.empty }
        func isLoggedIn() -> Bool { return false }
        func login(username: String, password: String) -> SignalProducer<UserEntity, UserError> { return SignalProducer.empty }
    }

    override func spec() {
        var network: NetworkStub!
        var userManager: UserManagerStub!
        var api: AuthTestAPIService!

        beforeEach {
            network = NetworkStub()
            userManager = UserManagerStub()
            let authHandler = AuthHandler { _ in
                SignalProducer { sink, dis in
                    userManager.credentials = Credentials(access_token: "secondToken", expires_in: 0, token_type: "Dummytokentype", scope: "", refresh_token: "")
                    sink.sendCompleted()
                }
            }
            api = AuthTestAPIService(network: network, authHandler: authHandler, userManager: userManager)
        }

        describe("Authenticated APIService") {
            it("refreshes token for single failed request") {
                var result: String? = nil
                api.testRequest()
                    .on(next: { result = $0 })
                    .start()
                network.expectedToken = "secondToken"
                expect(result).toEventuallyNot(beNil(), timeout: 10)
            }
        }

    }
}