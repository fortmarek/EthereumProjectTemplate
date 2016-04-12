//
//  ViewController.swift
//  ProjectName
//
//  Created by Dominik Vesely on 04/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LanguagesTableViewController: BaseViewController {

    let viewModel: LanguagesTableViewModeling!
    let detailControllerFactory: LanguageDetailTableViewControllerFactory!

    weak var activityIndicator: UIActivityIndicatorView!
    weak var tableView: UITableView!

    required init(viewModel: LanguagesTableViewModeling, detailControllerFactory: LanguageDetailTableViewControllerFactory) {
        self.viewModel = viewModel
        self.detailControllerFactory = detailControllerFactory
        super.init(nibName: nil, bundle: nil)
    }

    func setupBindings() {

        viewModel.cellModels.producer
            .on(next: { [weak self] languages in
                self?.tableView.reloadData()
        })
            .start()

        viewModel.loadLanguages.errors
            .takeUntil(rac_willDeallocSignal)
            .observeNext { [weak self] in
                self?.displayError($0)
        }

        activityIndicator.rac_animating <~ viewModel.loadLanguages.executing
        tableView.rac_hidden <~ viewModel.loadLanguages.executing
    }

    override func loadView() {
        super.loadView()

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

    var previewingContext: UIViewControllerPreviewing!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0

        viewModel.loadLanguages.apply().start()

        if #available(iOS 9.0, *) {
            previewingContext = registerForPreviewingWithDelegate(self, sourceView: tableView)
        }
    }

    override func viewWillAppear(animated: Bool) {
        if let selected = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(selected, animated: false)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func detailViewControllerForIndexPath(indexPath: NSIndexPath) -> UIViewController {
        let detailModel = viewModel.cellModels.value[indexPath.row]
        let controller = self.detailControllerFactory(viewModel: detailModel)
        return controller
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
        let controller = detailViewControllerForIndexPath(indexPath)
        navigationController?.pushViewController(controller, animated: true)
    }
}
//MARK : UIViewControllerPreviewingDelegate
extension LanguagesTableViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location) else { return nil }

        return detailViewControllerForIndexPath(indexPath)
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}
