//
//  ViewController.swift
//  ProjectName
//
//  Created by Dominik Vesely on 04/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LanguagesTableViewController: UIViewController {

    let viewModel: LanguagesTableViewModeling!
    let detailControllerFactory: LanguageDetailTableViewControllerFactory!

    weak var activityIndicator: UIActivityIndicatorView!
    weak var tableView: UITableView!

    required init(viewModel: LanguagesTableViewModeling, detailControllerFactory: LanguageDetailTableViewControllerFactory ) {
        self.viewModel = viewModel
        self.detailControllerFactory = detailControllerFactory
        super.init(nibName: nil, bundle: nil)
    }


    func setupBindings() {

        viewModel.cellModels.producer
            .on(next: {[weak self] _ in
                self?.tableView.reloadData()
            })
            .start()


        viewModel.errorMessage.producer
            .on(next: {[weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.displayErrorMessage(errorMessage)
                }
            })
            .start()


        activityIndicator.rac_animating <~ viewModel.loading.producer
        tableView.rac_hidden <~ viewModel.loading.producer

    }

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()

        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)

        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(tableView.superview!)
        }
        self.tableView = tableView

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(0)
        }

        self.activityIndicator = activityIndicator
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0

        viewModel.loadLanguages.apply().start()


    }

    override func viewWillAppear(animated: Bool) {
        if let selected = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(selected, animated: false)
        }
    }

    private func displayErrorMessage(errorMessage: String) {
        let title = L10n.LanguageTableNetworkErrorTitle.string
        let dismissButtonText = L10n.LanguageTableNetworkErrorDismiss.string
        let message = errorMessage
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: dismissButtonText, style: .Default) { _ in
            alert.dismissViewControllerAnimated(true, completion: nil)
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITableViewDataSource
extension LanguagesTableViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.value.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: LanguageTableViewCell = tableView.dequeCellForIndexPath(indexPath)
        cell.viewModel.value = viewModel.cellModels.value[indexPath.row]

        return cell
    }
}

// MARK: UITableViewDelegate
extension LanguagesTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailModel = viewModel.cellModels.value[indexPath.row]

        let controller = self.detailControllerFactory(viewModel: detailModel)
        self.navigationController?.pushViewController(controller, animated: true)

    }
}
