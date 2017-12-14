import Foundation

protocol HasAckeeViewModelFactory {
    var ackeeVMFactory: () -> AckeeViewModeling { get }
}

extension AppDependency: HasAckeeViewModelFactory {
    var ackeeVMFactory: () -> AckeeViewModeling { return { AckeeViewModel() } }
}
