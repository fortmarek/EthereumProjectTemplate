import UIKit

/// Base class for controllers containing `UICollectionView` as main view.
///
/// Register its `delegate` and `dataSource` in `viewDidLoad()`.
/// It isn't set in base implementation so no abstract implementation requiring fatalErrors and stuff is not required.
class BaseCollectionViewController<Layout: UICollectionViewLayout>: BaseViewController {
    
    let collectionViewLayout: Layout
    
    weak var collectionView: UICollectionView!
    
    // MARK: Initializers
    
    init(collectionViewLayout: Layout) {
        self.collectionViewLayout = collectionViewLayout
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    
    override func loadView() {
        super.loadView()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea) // is safe area what we really want?
        }
        self.collectionView = collectionView
    }
}
