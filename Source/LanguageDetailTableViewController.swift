//
//  LanguageDetailTableViewController.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/30/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import UIKit

class LanguageDetailTableViewController: UIViewController {
    let viewModel:LanguageDetailModeling
    
    init(viewModel:LanguageDetailModeling){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.redColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
