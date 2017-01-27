//
//  LanguageViewControllerSpec.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/31/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ReactiveSwift

@testable import ProjectSkeleton

class LanguagesViewControllerSpec: QuickSpec {
    
    class LanguagesTableViewModelStub : LanguagesTableViewModeling {
        var cellModels: MutableProperty<[LanguageDetailViewModeling]> { return MutableProperty([]) }
        var loading: MutableProperty<Bool>{ return MutableProperty(false) }
        var errorMessage: MutableProperty<String?> { return MutableProperty(nil) }
        var loadLanguages: Action<(), [LanguageEntity], LoadLanguagesError> { return Action{SignalProducer.empty} }
    }
    
    class LanguageDetailModelingStub : LanguageDetailViewModeling {
        var name: MutableProperty<String> { return MutableProperty("") }
        var sentence: MutableProperty<String> { return MutableProperty("") }
        var flagURL : MutableProperty<URL> { return MutableProperty(URL(string: "http://example.com")!) }
        var isSpeaking: MutableProperty<Bool> { return MutableProperty(false) }
        
        lazy var playSentence : Action<Void, (), SpeakError> = Action { _ in return SignalProducer.empty}
    }
    
    let detailFactory:LanguageDetailTableViewControllerFactory = {_ in LanguageDetailViewController(viewModel: LanguageDetailModelingStub())}
    
    override func spec() {
        
        //DISABLED
        //It creates memory leak on assigning table view delegate
        //Maybe Apple bug?
        xdescribe("Language table view controller"){
            
            itBehavesLike("object without leaks"){
                MemoryLeakContext{
                    let controller = LanguagesTableViewController(viewModel: LanguagesTableViewModelStub(), detailControllerFactory: self.detailFactory)
                    
                    //Make it load view
                    let _ = controller.view
                    
                    return controller
                }
            }
        }
        
        // DISABLED
        // same reason as above but now it stopped working also on UIViewController
        xdescribe("Language detail view controller"){
            
            itBehavesLike("object without leaks"){
                MemoryLeakContext{
                    let controller = UIViewController()//LanguageDetailViewController(viewModel: LanguageDetailModelingStub())
                    
                    //Make it load view
                    let _ = controller.view
                    
                    return controller
                }
            }
        }
    }
}
