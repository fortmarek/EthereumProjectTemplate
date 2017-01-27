//
//  LanguagesTableViewController.swift
//  ProjectSkeleton
//
//  Created by Dominik Vesely on 04/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveSwift

class LanguagesTableViewController: BaseViewController {

    let viewModel: LanguagesTableViewModeling!
    let detailControllerFactory: LanguageDetailTableViewControllerFactory!

    weak var activityIndicator: UIActivityIndicatorView!
    weak var tableView: UITableView!

    required init(viewModel: LanguagesTableViewModeling, detailControllerFactory: @escaping LanguageDetailTableViewControllerFactory) {
        self.viewModel = viewModel
        self.detailControllerFactory = detailControllerFactory
        super.init(nibName: nil, bundle: nil)
    }

    func setupBindings() {

        viewModel.cellModels.producer
            .on(value: { [weak self] languages in
                self?.tableView.reloadData()
        })
            .start()

        displayErrors(forAction: viewModel.loadLanguages)

        activityIndicator.reactive.isAnimating <~ viewModel.loadLanguages.isExecuting
        tableView.reactive.isHidden <~ viewModel.loadLanguages.isExecuting
    }

    override func loadView() {
        super.loadView()

        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(tableView.superview!)
        }
        self.tableView = tableView

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
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
            previewingContext = registerForPreviewing(with: self, sourceView: tableView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let selected = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selected, animated: false)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func detailViewControllerForIndexPath(_ indexPath: IndexPath) -> UIViewController {
        let detailModel = viewModel.cellModels.value[indexPath.row]
        let controller = self.detailControllerFactory(detailModel)
        return controller
    }
}

// MARK: UITableViewDataSource
extension LanguagesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageTableViewCell = tableView.dequeCellForIndexPath(indexPath)
        cell.viewModel.value = viewModel.cellModels.value[indexPath.row]

        return cell
    }
}

// MARK: UITableViewDelegate
extension LanguagesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = detailViewControllerForIndexPath(indexPath)
        navigationController?.pushViewController(controller, animated: true)
    }
}
//MARK : UIViewControllerPreviewingDelegate
extension LanguagesTableViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }

        return detailViewControllerForIndexPath(indexPath)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
