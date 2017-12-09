import Firebase
import ReactiveSwift

protocol FirebasePushObserving {
    func start()
}

final class FirebasePushObserver: FirebasePushObserving {
    
    private let pushManager: PushManaging
    
    // MARK: Initializers
    
    init(pushManager: PushManaging) {
        self.pushManager = pushManager
    }
    
    // MARK: Public interface
    
    func start() {
        pushManager.actions.registerToken <~ NotificationCenter.default.reactive.notifications(forName: .InstanceIDTokenRefresh)
            .filterMap { _ in InstanceID.instanceID().token() }
    }
}
