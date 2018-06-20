//
//  AckeeViewController.swift
//  Skeleton
//
//  Created by Jakub Olejník on 09/10/2017.
//

import UIKit
import SnapKit
import ReactiveSwift
import EtherKit

// MARK: ethereum project template notes
// - EtherKit is still in development. Currently its unusable in production.
// - EtherKit known issues:
//    EtherKit.request method has an error callback, but if an error occurs,
//      it gets lost in the underlying URLRequestManager and the callback is never called
// MARK: -----------



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

      etherKit.createKeyPair { [weak self] addressResult in
        guard let `self` = self else { assertionFailure(); return }
        switch addressResult {
        case let .failure(error):
          self.showError(error.localizedDescription)
        case let .success(address):
          print("--------------")
          print(address)

          self.etherKit.request(self.etherKit.balanceOf(address)) { [weak self] balanceResult in
            guard let `self` = self else { assertionFailure(); return }
            switch balanceResult {
            case let .failure(error):
              self.showError(error.localizedDescription)
            case let .success(balance):
              print("--------------")
              print(balance)
            }
          }
        }
      }
    }

  let etherKit = EtherKit(
    URL(string: "http://localhost:8545")!,
    connectionMode: .http,
    applicationTag: "cz.ackee.etherkit.example"
  )

    // MARK: Private helpers

    private func setupBindings() {
        imageView.reactive.image <~ viewModel.image
    }
}

extension UIViewController {
  func showError(_ message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    present(alert, animated: true)
  }
}
