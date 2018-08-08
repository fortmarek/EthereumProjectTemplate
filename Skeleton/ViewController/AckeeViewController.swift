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
import Result

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

      query.request(query.networkVersion()) {
        print($0)
      }

      //afaik etherkit cant import wallets (e.g. by mnemonic), but can generate new wallets.
      //upon reinstalling the app, call keyManager.createKeyPair. Write down the public address like below.
      //etherKit will be able to lookup the privateKey for this address in the keychain and sign transactions with it.
      //to make transactions from this address, you need some ether.
      //request it from the rinkeby faucet by following https://gist.github.com/cryptogoth/10a98e8078cfd69f7ca892ddbdcf26bc
      let myAddress = try! Address(describing: "0x94F076d506943387A0a6D758f4e7cfDDEDc3b738")

//      query.request(query.transactionCount(myAddress)) { result in
//        switch result {
//        case let .failure(error):
//          self.showError(error.localizedDescription)
//        case let .success(count):
//          print(count)
//        }
//
//      }

      let toAddress = try! Address(describing: "0xE9af3D5fB212ebfDA5785B8E7dfA2dB6dB3FEf44")

//      query.send(using: keyManager, from: myAddress, to: toAddress, value: UInt256(0x131c00000000000)) { result in
//        switch result {
//        case let .failure(error):
//          self.showError(error.localizedDescription)
//        case let .success(value):
//          print(value)
//        }
//      }
      query.request(query.balanceOf(myAddress)) { [weak self] balanceResult in
        guard let `self` = self else { assertionFailure(); return }
        switch balanceResult {
        case let .failure(error):
          self.showError(error.localizedDescription)
        case let .success(balance):
          print("--------------")
          print(balance)
        }
      }

//      keyManager.createKeyPair { [weak self] addressResult in
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

      // I have a HelloWorld contract running at this address, it has the following ABI:
      // [ { "constant": true, "inputs": [ { "name": "message", "type": "string" } ], "name": "say", "outputs": [ { "name": "result", "type": "string", "value": "" } ], "payable": false, "stateMutability": "pure", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" } ]
      // We want to be able to call its "say" function with a String parameter. It should return a String.
      let helloWorldContractAddress = try! Address(describing: "0x4a1CC51e501c4FaC88087B0F83aDfdA77c46Aaee")
      let sayHiFunctionCall = Function(functionSelector: FunctionSelector(name: "say", parameterTypes: [.string(value: "Why do I need to specify a value here? Ill pass it later in parameters too, and that one will get used")]), parameters: ["Hey"])
      let sayHiData = GeneralData(data: sayHiFunctionCall.encodeToCall())
      query.send(using: keyManager, from: myAddress, to: toAddress, value: UInt256(0x131c00000000000), data: sayHiData) { result in
        switch result {
        case let .failure(error):
          self.showError(error.localizedDescription)
        case let .success(value):
          print(value)
        }
      }

//      query.sayHi(using: keyManager, from: myAddress, to: helloWorldContractAddress, value: UInt256(0x100000000000000)) { result in
//          print(result)
//      }

    }

  let keyManager = EtherKeyManager(applicationTag: "cz.ackee.etherkit.example")

  let query = EtherQuery(URL(string: "https://geth-infrastruktura-master.ack.ee")!, connectionMode: .http)
//    URL(string: "http://localhost:8545")!,

    // MARK: Private helpers

    private func setupBindings() {
        imageView.reactive.image <~ viewModel.image
    }
}

// This is a basic example. We will want to find a nicer API for this. Im thinking, nest function of each contract inside its own namespace, i.e:
// let producer: SignalProducer<Value, EtherKitError> = etherKit.helloWorldContract.sayHi(sender:to:value:parameters:),
// where parameters is a tuple of parameters of the function and Value is the return type
// Maybe even explore something like etherKit.helloWorldContract(at:/*ContractAddressHere*/).sayHi(.....)

/*extension EtherQuery {
  public func sayHi(
    using keyManager: EtherKeyManager,
    from sender: Address,
    to: Address,
    value: UInt256,
    completion: @escaping (Result<Hash, EtherKitError>) -> Void
    ) {
    request(
      networkVersion(),
      transactionCount(sender, blockNumber: .pending)
    ) { result in
      switch result {
      case let .success(items):

        let (network, nonce) = items
        
        /*keyManager.sign(
          with: sender,
          transaction: TransactionCall(
            nonce: UInt256(nonce.describing),
            to: to,
            gasLimit: UInt256(22000),
            // 21000 is the current base value for any transaction (e.g. just sending ether)
            // if the transaction includes data, it needs more gat depending on how many bytes are used
            // see https://ethereum.stackexchange.com/questions/1570/mist-what-does-intrinsic-gas-too-low-mean
            // TODO: calculate and use the right ammount of gas
            // TODO: find out how this value changes overtime, maybe EtherKit shouldnt be hardcoding the 21000 constant
//            gasLimit: UInt256(21000),
            gasPrice: UInt256(20_000_000_000),
            value: value
            // TODO: pass serialized function selector and parameters
            // Currently we'd have to serialize the function selector and argument as per https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI
            // Im hoping to get EtherKit to support this for us (https://github.com/Vaultio/EtherKit/issues/19)
//            data: try! GeneralData.value(from: contractFunctionNameAndParams)
          ),
          network: network
        ) {
          switch $0 {
          case let .success(signedTransaction):
            let encodedData = RLPData.encode(from: signedTransaction)
            let sendRequest = SendRawTransactionRequest(SendRawTransactionRequest.Parameters(data: encodedData))
            self.request(sendRequest) { completion($0) }
          case let .failure(error):
            completion(.failure(error))
          }
        }*/
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}*/

extension UIViewController {
  func showError(_ message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    present(alert, animated: true)
  }
}
