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
//
//      etherKit.request(etherKit.networkVersion()) {
//        print($0)
//      }

      //afaik etherkit cant import wallets (e.g. by mnemonic), but can generate new wallets.
      //upon reinstalling the app, call etherKit.createKeyPair. Write down the public address like below.
      //etherKit will be able to lookup the privateKey for this address in the keychain and sign transactions with it.
      //to make transactions from this address, you need some ether.
      //request it from the rinkeby faucet by following https://gist.github.com/cryptogoth/10a98e8078cfd69f7ca892ddbdcf26bc
      let myAddress = try! Address(describing: "0x2f3B8f93686e2864b6cB1b4DB43fC6DfaA1642DD")

//      etherKit.request(self.etherKit.transactionCount(myAddress)) { result in
//        switch result {
//        case let .failure(error):
//          self.showError(error.localizedDescription)
//        case let .success(count):
//          print(count)
//        }
//
//      }

      let toAddress = try! Address(describing: "0xE9af3D5fB212ebfDA5785B8E7dfA2dB6dB3FEf44")

//      etherKit.send(with: myAddress, to: toAddress, value: UInt256(0x131c00000000000)) { result in
//        switch result {
//        case let .failure(error):
//          self.showError(error.localizedDescription)
//        case let .success(value):
//          print(value)
//        }
//      }
//      self.etherKit.request(self.etherKit.balanceOf(myAddress)) { [weak self] balanceResult in
//        guard let `self` = self else { assertionFailure(); return }
//        switch balanceResult {
//        case let .failure(error):
//          self.showError(error.localizedDescription)
//        case let .success(balance):
//          print("--------------")
//          print(balance)
//        }
//      }
//      do {
//        try etherKit.keyManager.sign(Data(), for: myAddress) { data, godKnows in
//          print(data, godKnows)
//        }
//      } catch {
//        print(error)
//      }

//      etherKit.createKeyPair { [weak self] addressResult in
//        guard let `self` = self else { assertionFailure(); return }
//        switch addressResult {
//        case let .failure(error):
//          self.showError(error.localizedDescription)
//        case let .success(address):
//          print("--------------")
//          print(address)
//
//        }
//      }

    }

  let etherKit = EtherKit(
//    URL(string: "http://localhost:8545")!,
    URL(string: "https://geth-infrastruktura-master.ack.ee")!,
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
