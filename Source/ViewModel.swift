//
//  ViewModel.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 2/1/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa

protocol ViewModeling{
    
}

class ViewModel: ViewModeling {
    
    //MARK: Initialization
    required init(){
        self.setupBindings()
    }
    
    //MARK: Bindings
    func setupBindings(){
        
    }
}
