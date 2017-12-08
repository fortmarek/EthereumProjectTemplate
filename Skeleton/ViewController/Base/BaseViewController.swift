import UIKit

/// Base class for all view controllers contained in app.
class BaseViewController: UIViewController {
    
    // MARK: Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View life cycle
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
    }
}
