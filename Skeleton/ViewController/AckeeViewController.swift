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
// - The service Infura.io provides an ethereum node accessible over https, We can use the API Key EcrxWYU15S7Yu5vJNDzX , e.g access the Ropsten testnet using the url https://ropsten.infura.io/EcrxWYU15S7Yu5vJNDzX
//    Unfortunatelly, Infura doesnt adhere to the JSONRPC spec (doesnt support String id's), so it cant be used with the current version of EtherKit
// - We can work against a local ethereum node, run e.g. `geth --testnet --rpc --rpcaddr "127.0.0.1" --rpcport "8545" console`, then access it at http://localhost:8545
//    I couldnt get it to work over https, so NSAppTransportSecurity/NSAllowsArbitraryLoads has been set in the info.plist for now

// - EtherKit known issues:
//   - When using EtherKit over http, geth seems to require Content-Type application/json header (else returns 415). Edit URLRequestManager.swift queueRequest method to add the header (we should make a PR into EtherKit)
//   - EtherKit.request method has an error callback, but if an error occurs,
//      it gets lost in the underlying URLRequestManager and the callback is never called
//   - There are more potential places where a method's callback might not get called.
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
