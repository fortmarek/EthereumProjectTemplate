import Quick
import Nimble
import ReactiveCocoa
import Alamofire
@testable import SampleTestingProject

private let networkQueue = dispatch_queue_create("networkQueue", DISPATCH_QUEUE_CONCURRENT)
private let authHandlerQueue = dispatch_queue_create("authHandlerQueue", DISPATCH_QUEUE_CONCURRENT)

class AuthenticatedAPIServiceSpec: QuickSpec {
    class AuthTestAPIService: AuthenticatedAPIService {
        func testRequest(requestDelay requestDelay: Int, responseDelay: Int) -> SignalProducer<String, RequestError> {
            return request("dummyUrl", method: .GET, parameters: ["requestDelay": requestDelay, "responseDelay": responseDelay], encoding: .URL, headers: [:])
                .map { $0 as! String }
                .mapError { .Network($0) }
        }
    }

    class NetworkStub: Networking {
        var expectedToken: String = "firstToken"

        func request(url: String, method: Alamofire.Method, parameters: [String: AnyObject]?, encoding: ParameterEncoding, headers: [String: String]?, useDisposables: Bool) -> SignalProducer<AnyObject, NetworkError> {
            let requestDelay = parameters?["requestDelay"] as! Double
            let responseDelay = parameters?["responseDelay"] as! Double

            return SignalProducer { [unowned self] sink, dis in
                dispatch_async(networkQueue) {
                    usleep(UInt32(requestDelay))
                    switch headers?["Authorization"] {
                    case .Some(let token) where token.stringByReplacingOccurrencesOfString("Dummytokentype ", withString: "", options: NSStringCompareOptions()) == self.expectedToken:
                        usleep(UInt32(requestDelay))
                        sink.sendNext("dummyResult"); sink.sendCompleted()
                    default: // didnt get correct token, return 401
                        let theUrl = NSURL(string: url)!
                        let originalRequest = NSMutableURLRequest(URL: theUrl) // mimic alamofire behaviour
                        originalRequest.allHTTPHeaderFields = headers
                        let response = NSHTTPURLResponse(URL: theUrl, statusCode: 401, HTTPVersion: nil, headerFields: nil)
                        usleep(UInt32(requestDelay))
                        sink.sendFailed(NetworkError(error: NSError(domain: "ctyristajednicka", code: 0, userInfo: nil), request: originalRequest, response: response))
                    }

                }
            }
        }

    }

    class UserManagerStub: UserManaging {
        var user: MutableProperty<UserEntity?> = MutableProperty(nil)
        var credentials: Credentials? = Credentials(access_token: "firstToken", expires_in: 0, token_type: "Dummytokentype", scope: "", refresh_token: "")
        func logout() -> SignalProducer<(), NoError> { return SignalProducer.empty }
        func isLoggedIn() -> Bool { return false }
        func login(username: String, password: String) -> SignalProducer<UserEntity, UserError> { return SignalProducer.empty }
    }

    // NOTE: all requests must finish in under a seconds, or toEventually will start polling before requests have been finished. Use waitUntil if you need longer requests
    override func spec() {
        var network: NetworkStub!
        var authHandler: AuthHandler!
        var userManager: UserManagerStub!
        var api: AuthTestAPIService!

        // this token is used in this test for two purposes.
        // 1) AuthHandler stores its value on 'started' and sets it to userManager after 1 second, then completes
        // 2) We set this into NetworkStub.expectedToken . The NetworkStub then checks that the request's token matches this value, and returns 401 otherwise.
        var expectedToken: String = "firstToken" {
            didSet {
                network.expectedToken = expectedToken
            }
        }

        var authHandlerInvoked = 0

        beforeEach {
            network = NetworkStub()
            userManager = UserManagerStub()
            authHandler = AuthHandler { _ in
                let currentToken = expectedToken
                return SignalProducer { sink, dis in
                    dispatch_async(authHandlerQueue) {
                        usleep(10)
                        userManager.credentials = Credentials(access_token: currentToken, expires_in: 0, token_type: "Dummytokentype", scope: "", refresh_token: "")
                        sink.sendCompleted()
                    }
                }.on(started: { authHandlerInvoked = authHandlerInvoked + 1 })
            }
            authHandlerInvoked = 0
            api = AuthTestAPIService(network: network, authHandler: authHandler, userManager: userManager)
        }

        describe("Authenticated APIService") {

            it("refreshes token and retries a single failed request") {
                var result: String? = nil
                api.testRequest(requestDelay: 1, responseDelay: 1)
                    .on(next: { result = $0 })
                    .start()
                expectedToken = "secondToken"

                expect(authHandlerInvoked).toEventually(be(1), timeout: 20)
                expect(result).toEventuallyNot(beNil(), timeout: 20)
            }

            it("refreshes token only once and retries requests when all requests take the same time") {
                var result1: String? = nil
                var result2: String? = nil

                // req1
                api.testRequest(requestDelay: 1, responseDelay: 1)
                    .on(next: { result1 = $0 })
                    .start()
                // req2
                api.testRequest(requestDelay: 1, responseDelay: 1)
                    .on(next: { result2 = $0 })
                    .start()

                expectedToken = "secondToken"

                expect(authHandlerInvoked).toEventually(be(1), timeout: 20)
                expect(result1).toEventuallyNot(beNil(), timeout: 20)
                expect(result2).toEventuallyNot(beNil(), timeout: 20)
            }

            it("refreshes token only once and retries requests when second request fails after token has been refreshed") {
                var result1: String? = nil
                var result2: String? = nil

                // req1
                api.testRequest(requestDelay: 1, responseDelay: 1)
                    .on(next: { result1 = $0 })
                    .start()
                // req2
                api.testRequest(requestDelay: 20, responseDelay: 1)
                    .on(next: { result2 = $0 })
                    .start()

                expectedToken = "secondToken"

                expect(authHandlerInvoked).toEventually(be(1))
                expect(result1).toEventuallyNot(beNil())
                expect(result2).toEventuallyNot(beNil())
            }

//            it("just works") {
//                let numberOfRequests = 10
//                var results: [String] = []
//
//                waitUntil(timeout: 10) { done in
//
//                    for _ in 0..<numberOfRequests {
//                        api.testRequest(requestDelay: Int(arc4random_uniform(50)), responseDelay: Int(arc4random_uniform(50)))
//                            .on(next: { results.append($0) },
//                                terminated: {
//                                    print(results.count)
//                                    if results.count == numberOfRequests { done() }
//                        })
//                            .start()
//                    }
//                }
//
//            }
        }

    }

}