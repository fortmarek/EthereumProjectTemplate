import Foundation

protocol FlowController: class {
    var childControllers: [FlowController] { get set }
    
    func addChild(_ flowController: FlowController)
    func start()
}

extension FlowController {
    func addChild(_ flowController: FlowController) {
        if !childControllers.contains { $0 === flowController } {
            childControllers.append(flowController)
        }
    }
    
    func removeChild(_ flowController: FlowController) {
        if let index = childControllers.index (where: { $0 === flowController }) {
            childControllers.remove(at: index)
        }
    }
}
