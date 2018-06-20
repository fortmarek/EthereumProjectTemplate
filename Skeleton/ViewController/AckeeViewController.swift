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

// MARK: notes
// - EtherKit is still in development. Currently its unusable in production.
// - EtherKit known issues:
//   - EtherKit.request method has an error callback, but if an error occurs,
//      it gets lost in the underlying URLRequestManager and the callback is never called
//   - There are more potential places where a method's callback might not get called.
// MARK: -----------
// MARK: other (less important) notes:
// - Ive signed up for Infura.io, which should let us test communication with the ethereum network without running a node.
//    I signed up with petr.sima@ackee.cz, theres no password and no login screen wtf
//    Infura API Key: EcrxWYU15S7Yu5vJNDzX , you can access e.g. the Ropsten testnet using the url https://ropsten.infura.io/EcrxWYU15S7Yu5vJNDzX
//    Unfortunatelly, Infura doesnt adhere to the JSONRPC spec (doesnt support String id's), so it cant be used with the currect version of EtherKit
//

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

      etherKit.request(etherKit.networkVersion()) {
          print($0)
      }

//      etherKit.createKeyPair { [weak self] addressResult in
//        guard let `self` = self else { assertionFailure(); return }
//        switch addressResult {
//        case let .failure(error):
//          self.showError(error.localizedDescription)
//        case let .success(address):
//          print("--------------")
//          print(address)
//
//          self.etherKit.request(self.etherKit.balanceOf(address)) { [weak self] balanceResult in
//            guard let `self` = self else { assertionFailure(); return }
//            switch balanceResult {
//            case let .failure(error):
//              self.showError(error.localizedDescription)
//            case let .success(balance):
//              print("--------------")
//              print(balance)
//            }
//          }
//        }
//      }
    }

  let etherKit = EtherKit(
    URL(string: "https://ropsten.infura.io/EcrxWYU15S7Yu5vJNDzX")!,
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
