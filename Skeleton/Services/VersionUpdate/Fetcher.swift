import Foundation

public protocol Fetcher {
    var version: Int? { get }
    
    func fetch(completion: @escaping () -> Void)
}
