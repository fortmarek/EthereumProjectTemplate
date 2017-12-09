import ReactiveSwift

protocol PushAPIServicing {
    func registerToken(_ token: String) -> SignalProducer<Void, RequestError>
}

final class PushAPIService: PushAPIServicing {
    
    private let jsonAPI: JSONAPIServicing
    
    // MARK: Initializers
    
    init(jsonAPI: JSONAPIServicing) {
        self.jsonAPI = jsonAPI
    }
    
    func registerToken(_ token: String) -> SignalProducer<Void, RequestError> {
        return jsonAPI.request(RequestAddress(path: "devices/token"), method: .put, parameters: ["token": token])
            .map { _ in }
    }
}
