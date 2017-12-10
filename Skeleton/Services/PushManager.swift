import ReactiveSwift
import UserNotifications

import enum Result.NoError
typealias NoError = Result.NoError

protocol HasPushManager {
    var pushManager: PushManaging { get }
}

protocol PushManagingNotifications {
    var received: Signal<PushNotification, NoError> { get }
    var opened: Signal<PushNotification, NoError> { get }
}

protocol PushManagingActions {
    var registerToken: Action<String, Void, RequestError> { get }
}

protocol PushManaging {
    var notifications: PushManagingNotifications { get }
    var actions: PushManagingActions { get }
    
    func start()
}

final class PushManager: NSObject, PushManaging, PushManagingNotifications, PushManagingActions {
    typealias Dependencies = HasPushAPI
    
    var notifications: PushManagingNotifications { return self }
    var actions: PushManagingActions { return self }

    let (received, receivedObserver) = Signal<PushNotification, NoError>.pipe()
    let (opened, openedObserver) = Signal<PushNotification, NoError>.pipe()
    let registerToken: Action<String, Void, RequestError>
    
    // MARK: Initializers
    
    init(dependencies: Dependencies) {
        registerToken = Action { dependencies.pushAPI.registerToken($0) }
    }
    
    // MARK: Public interface
    
    func start() {
        UNUserNotificationCenter.current().delegate = self
    }
}

extension PushManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let pushNotification = PushNotification(notification: response.notification) {
            receivedObserver.send(value: pushNotification)
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let pushNotification = PushNotification(notification: notification) {
            openedObserver.send(value: pushNotification)
        }
        completionHandler(.all)
    }
}
