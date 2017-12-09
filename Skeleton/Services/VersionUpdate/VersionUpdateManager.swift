import ReactiveSwift

public protocol VersionUpdateManaging {
    var updateRequired: Property<Bool> { get }
    
    func setup()
}

public class VersionUpdateManager: VersionUpdateManaging {
    public let updateRequired: Property<Bool>
    
    private let _updateRequired = MutableProperty(false)
    private let fetcher: Fetcher
    
    // MARK: Initializers 
    
    public init(fetcher: Fetcher) {
        updateRequired = Property(capturing: _updateRequired)
        self.fetcher = fetcher
    }
    
    // MARK: Public interface
    
    public func setup() {
        update()
        
        fetcher.fetch { [weak self] in self?.update() }
    }
    
    // MARK: Private helpers
    
    private func update() {
        guard
            let currentVersion = Bundle.main.infoDictionary?["CFBundleVersion"].flatMap({ $0 as? String }).flatMap({ Int($0) }),
            let configVersion = fetcher.version
        else { return }
        
        _updateRequired.value = currentVersion < configVersion
    }
    
}
