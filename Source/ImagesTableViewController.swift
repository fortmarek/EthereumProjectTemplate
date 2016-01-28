//
//  ViewController.swift
//  ProjectName
//
//  Created by Dominik Vesely on 04/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class ImagesTableViewController : UITableViewController {
    
    var viewModel: ImagesTableViewModeling!
    
    required init(viewModel: ImagesTableViewModeling){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    func setupBindings(){
        
        viewModel.cellModels.producer
            .on(next: { _ in
                
                self.tableView.reloadData()
            })
            .start()
        
        
        viewModel.errorMessage.producer
            .on(next: { errorMessage in
                if let errorMessage = errorMessage {
                    self.displayErrorMessage(errorMessage)
                }
            })
            .start()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
        
        viewModel.loadImages.apply().start()
        
        
    }
    
    private func displayErrorMessage(errorMessage: String) {
        let title = NSLocalizedString("ImageSearchTableViewController_ErrorAlertTitle", comment: "Error alert title.")
        let dismissButtonText = NSLocalizedString("ImageSearchTableViewController_DismissButtonTitle", comment: "Dismiss button title on an alert.")
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
extension ImagesTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.value.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ImageTableViewCell = tableView.dequeCellForIndexPath(indexPath)
        cell.viewModel = viewModel.cellModels.value[indexPath.row]
        
        return cell
    }
}



