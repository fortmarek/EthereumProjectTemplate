import Quick
import Nimble
import ReactiveSwift
import Alamofire
@testable import ProjectSkeleton

private let networkQueue = DispatchQueue(label: "networkQueue", attributes: .concurrent)
private let authHandlerQueue = DispatchQueue(label: "authHandlerQueue", attributes: .concurrent)

private let testURLString = "http://example.com"

class AuthenticatedAPIServiceSpec: QuickSpec {
    class AuthTestAPIService: AuthenticatedAPIService {
        func testRequest(_ url: String, requestDelay: Double, responseDelay: Double) -> SignalProducer<String, RequestError> {
            return request(url, method: .get, parameters: ["requestDelay": requestDelay, "responseDelay": responseDelay], encoding: URLEncoding.default, headers: [:])
                .map { $0 as! String }
                .mapError { .network($0) }
        }
    }

    class NetworkStub: Networking {
        var expectedToken: String = "firstToken"

        func request(_ url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]?, encoding: ParameterEncoding, headers: [String: String]?, useDisposables: Bool) -> SignalProducer<Any, NetworkError> {
            let requestDelay = parameters?["requestDelay"] as! Double
            let responseDelay = parameters?["responseDelay"] as! Double

            return SignalProducer { [unowned self] sink, dis in
                networkQueue.async {
                    usleep(UInt32(requestDelay) * 1000)
                    switch headers?["Authorization"] {
                    case .some(let token) where token.replacingOccurrences(of: "Dummytokentype ", with: "", options: NSString.CompareOptions()) == self.expectedToken:
                        usleep(UInt32(requestDelay) * 1000)
                        sink.send(value: url); sink.sendCompleted()
                    default: // didnt get correct token, return 401
                        let theUrl = URL(string: url)!
                        let originalRequest = NSMutableURLRequest(url: theUrl) // mimic alamofire behaviour
                        originalRequest.allHTTPHeaderFields = headers
                        let response = HTTPURLResponse(url: theUrl, statusCode: 401, httpVersion: nil, headerFields: nil)
                        usleep(UInt32(requestDelay) * 1000)
                        sink.send(error: NetworkError(error: NSError(domain: "ctyristajednicka", code: 0, userInfo: nil), request: originalRequest as URLRequest, response: response))
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
        func login(_ username: String, password: String) -> SignalProducer<UserEntity, UserError> { return SignalProducer.empty }
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
                    authHandlerQueue.async {
                        print("refreshing token")
                        usleep(10 * 1000)
                        let token = currentToken
                        usleep(10 * 1000)
                        userManager.credentials = Credentials(access_token: token, expires_in: 0, token_type: "Dummytokentype", scope: "", refresh_token: "")
                        print("token refreshed")
                        sink.sendCompleted()
                    }
                }.on(started: {
                    print(authHandlerInvoked)
                    authHandlerInvoked = authHandlerInvoked + 1
                    print(authHandlerInvoked)
                })
            }
            authHandlerInvoked = 0
            api = AuthTestAPIService(network: network, authHandler: authHandler, userManager: userManager)
        }

        describe("Authenticated APIService") {

            it("refreshes token and retries a single failed request") {
                var result: String? = nil
                api.testRequest(testURLString, requestDelay: 1.0, responseDelay: 1.0)
                    .observe(on: QueueScheduler.main)
                    .on(value: { result = $0 })
                    .start()
                expectedToken = "secondToken"

                expect(authHandlerInvoked).toEventually(be(1))
                expect(result).toEventuallyNot(beNil())
            }

            it("refreshes token only once and retries requests when all requests take the same time") {
                var result1: String? = nil
                var result2: String? = nil

                waitUntil(timeout: 10) { done in
                    // req1
                    api.testRequest(testURLString, requestDelay: 1, responseDelay: 1)
                        .observe(on: QueueScheduler.main)
                        .on(value: {
                            result1 = $0
                            if result1 != nil && result2 != nil { done() }
                    })
                        .start()
                    // req2
                    api.testRequest(testURLString, requestDelay: 1, responseDelay: 1)
                        .observe(on: QueueScheduler.main)
                        .on(value: {
                            result2 = $0
                            if result1 != nil && result2 != nil { done() }
                    })
                        .start()

                    expectedToken = "secondToken"

                }

                expect(authHandlerInvoked).to(be(1))
            }

            it("refreshes token only once and retries requests when second request fails after token has been refreshed") {
                var result1: String? = nil
                var result2: String? = nil

                waitUntil(timeout: 10) { done in
                    // req1
                    api.testRequest(testURLString, requestDelay: 1, responseDelay: 1)
                        .observe(on: QueueScheduler.main)
                        .on(value: {
                            result1 = $0
                            if result1 != nil && result2 != nil { done() }
                    })
                        .start()
                    // req2
                    api.testRequest(testURLString, requestDelay: 200, responseDelay: 1)
                        .observe(on: QueueScheduler.main)
                        .on(value: {
                            result2 = $0
                            if result1 != nil && result2 != nil { done() }
                    })
                        .start()

                    expectedToken = "secondToken"

                }

                expect(authHandlerInvoked).to(be(1))
            }

            it("just works") {
                let numberOfRequests = 1000
                var results: [String] = []

                func changeExpectedTokenAfterRandomDelay() {

                    func changeExpectedToken() {

                        func randomString(_ length: Int) -> String {
                            let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                            let charactersArray = Array(arrayLiteral: charactersString)

                            var string = ""
                            for _ in 0..<length {
                                string += charactersArray[Int(arc4random()) % charactersArray.count]
                            }

                            return string
                        }
                        print("changing token")
                        expectedToken = randomString(10)
                    }

                    changeExpectedToken()

                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(arc4random_uniform(30)) / Double(1000)) {
                        changeExpectedTokenAfterRandomDelay()
                    }
                    
                }

                waitUntil(timeout: 10) { done in

                    let once: () = {
                        done()
                    }()

                    for i in 0..<numberOfRequests {
                        api.testRequest("\(testURLString)/\(i)", requestDelay: Double(arc4random_uniform(50)), responseDelay: Double(arc4random_uniform(50)))
                            .observe(on: QueueScheduler.main)
                            .on(value: {
                                results.append($0)
                                },
                                terminated: {
                                    if results.count == numberOfRequests {
                                        _ = once // the observeOn above causes next and completed to not be delivered serially, even though they were sent serially from another thread. So we can have req1.next, req2.next, req1.completed. Thus we need the dispatch_once to prevent done() from being called multiple times.
                                    }
                        })
                            .start()
                    }

                    changeExpectedTokenAfterRandomDelay()
                }

            }
        }

    }

}
