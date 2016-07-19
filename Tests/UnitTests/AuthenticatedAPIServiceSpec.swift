import Quick
import Nimble
import ReactiveCocoa
import Alamofire
@testable import GrenkePlayground

private let networkQueue = dispatch_queue_create("networkQueue", DISPATCH_QUEUE_CONCURRENT)
private let authHandlerQueue = dispatch_queue_create("authHandlerQueue", DISPATCH_QUEUE_CONCURRENT)

class AuthenticatedAPIServiceSpec: QuickSpec {
    class AuthTestAPIService: AuthenticatedAPIService {
        func testRequest(url url: String, requestDelay: Int, responseDelay: Int) -> SignalProducer<String, RequestError> {
            return request(url, method: .GET, parameters: ["requestDelay": requestDelay, "responseDelay": responseDelay], encoding: .URL, headers: [:])
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
                    usleep(UInt32(requestDelay) * 1000)
                    switch headers?["Authorization"] {
                    case .Some(let token) where token.stringByReplacingOccurrencesOfString("Dummytokentype ", withString: "", options: NSStringCompareOptions()) == self.expectedToken:
                        usleep(UInt32(requestDelay) * 1000)
                        sink.sendNext(url); sink.sendCompleted()
                    default: // didnt get correct token, return 401
                        let theUrl = NSURL(string: url)!
                        let originalRequest = NSMutableURLRequest(URL: theUrl) // mimic alamofire behaviour
                        originalRequest.allHTTPHeaderFields = headers
                        let response = NSHTTPURLResponse(URL: theUrl, statusCode: 401, HTTPVersion: nil, headerFields: nil)
                        usleep(UInt32(requestDelay) * 1000)
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
                api.testRequest(url: "", requestDelay: 1, responseDelay: 1)
                    .observeOn(QueueScheduler.mainQueueScheduler)
                    .on(next: { result = $0 })
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
                    api.testRequest(url: "", requestDelay: 1, responseDelay: 1)
                        .observeOn(QueueScheduler.mainQueueScheduler)
                        .on(next: {
                            result1 = $0
                            if result1 != nil && result2 != nil { done() }
                    })
                        .start()
                    // req2
                    api.testRequest(url: "", requestDelay: 1, responseDelay: 1)
                        .observeOn(QueueScheduler.mainQueueScheduler)
                        .on(next: {
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
                    api.testRequest(url: "", requestDelay: 1, responseDelay: 1)
                        .observeOn(QueueScheduler.mainQueueScheduler)
                        .on(next: {
                            result1 = $0
                            if result1 != nil && result2 != nil { done() }
                    })
                        .start()
                    // req2
                    api.testRequest(url: "", requestDelay: 200, responseDelay: 1)
                        .observeOn(QueueScheduler.mainQueueScheduler)
                        .on(next: {
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

                        func randomString(length: Int) -> String {
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

                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64((Double(arc4random_uniform(30)) / Double(1000)) * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        changeExpectedTokenAfterRandomDelay()
                    }

                }

                waitUntil(timeout: 10) { done in

                    var token: dispatch_once_t = 0

                    for i in 0..<numberOfRequests {
                        api.testRequest(url: "\(i)", requestDelay: Int(arc4random_uniform(50)), responseDelay: Int(arc4random_uniform(50)))
                            .observeOn(QueueScheduler.mainQueueScheduler)
                            .on(next: {
                                results.append($0)
                                },
                                terminated: {
                                    if results.count == numberOfRequests {
                                        dispatch_once(&token) { // the observeOn above causes next and completed to not be delivered serially, even though they were sent serially from another thread. So we can have req1.next, req2.next, req1.completed. Thus we need the dispatch_once to prevent done() from being called multiple times.
                                            done()
                                        }
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
