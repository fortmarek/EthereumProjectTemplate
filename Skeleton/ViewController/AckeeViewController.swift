//
//  AckeeViewController.swift
//  Skeleton
//
//  Created by Jakub Olejník on 09/10/2017.
//

import UIKit
import SnapKit
import ReactiveSwift

final class AckeeViewController: BaseViewController {

    private let viewModel: AckeeViewModeling

    private weak var imageView: UIImageView!

    // MARK: Initializers

    init(viewModel: AckeeViewModeling) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View life cycle

    override func loadView() {
        super.loadView()

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().inset(60)
        }
        self.imageView = imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    // MARK: Private helpers

    private func setupBindings() {
        imageView.reactive.image <~ viewModel.image
    }
}
