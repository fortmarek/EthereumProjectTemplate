import UIKit

final class AppFlowController: FlowController {
    var childControllers = [FlowController]()

    private let window: UIWindow

    // MARK: Initializers

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: Public interface

    func start() {
        window.rootViewController = AckeeViewController(viewModel: AckeeViewModel())
    }

    func handle(routingAction action: RoutingAction) {

    }
}
