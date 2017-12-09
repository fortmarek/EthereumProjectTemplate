import ReactiveSwift
import UserNotifications

import enum Result.NoError
typealias NoError = Result.NoError

protocol Notifications {
    var received: Signal<PushNotification, NoError> { get }
    var opened: Signal<PushNotification, NoError> { get }
}

protocol PushManaging {
    var notifications: Notifications { get }
    
    func start()
}

final class PushManager: NSObject, PushManaging, Notifications {
    var notifications: Notifications { return self }

    let (received, receivedObserver) = Signal<PushNotification, NoError>.pipe()
    let (opened, openedObserver) = Signal<PushNotification, NoError>.pipe()
    
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
