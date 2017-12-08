import UIKit

/// Base class for controllers containing `UITableView` as main view.
///
/// Register its `delegate` and `dataSource` in `viewDidLoad()`.
/// It isn't set in base implementation so no abstract implementation requiring fatalErrors and stuff is not required.
class BaseTableViewController: BaseViewController {
    
    weak var tableView: UITableView!
    
    private let tableViewStyle: UITableViewStyle
    
    // MARK: Initializers
    
    init(tableViewStyle: UITableViewStyle = .grouped) {
        self.tableViewStyle = tableViewStyle
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: tableViewStyle)
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea) // is safe area what we really want?
        }
        self.tableView = tableView
    }
}
