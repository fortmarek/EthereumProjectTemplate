//
//  ViewController.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 2/1/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    
    //MARK: Dependencies
    let viewModel:ViewModeling
    
    
    //MARK: Initialization
    required init(viewModel:ViewModeling){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: Bindings
    func setupBindings(){
        
    }
    
    //MARK: Life cycle
    override func loadView(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }
    
    
    //MARK: Other
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}