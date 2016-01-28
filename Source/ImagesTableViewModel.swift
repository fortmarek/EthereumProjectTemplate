//
//  ImagesTableViewModel.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa

class ImagesTableViewModel: ImagesTableViewModeling {
    
    var cellModels = MutableProperty<[ImagesTableViewCellModeling]>([])
    var loading = MutableProperty<Bool>(false)
    var errorMessage = MutableProperty<String?>(nil)
    
    
    //MARK: Action
    
    private var canLoadImages: AnyProperty<Bool> {
        return AnyProperty(
            initialValue: true,
            producer: loading.producer.map{!$0})
    }
    
    var loadImages: Action<(), [ImageEntity], NSError> {
        return Action(enabledIf: canLoadImages) { _ in
            self.loading.value = true
            
            return self.api.loadImages(1)
                .observeOn(UIScheduler())
                .on(
                    next: { images in
                        self.cellModels.value = images.map{ ImagesTableViewCellModel(image:$0)}
                        self.loading.value = false
                    },
                    failed:{ error in
                        //TODO: change
                        self.errorMessage.value = "There was an error"
                    }
            )
        }
    }
    
    //MARK: Dependencies
    private let api: API
    
    
    private var foundImages = [ImageEntity]()
    
    init(api: API) {
        self.api = api
    }
}