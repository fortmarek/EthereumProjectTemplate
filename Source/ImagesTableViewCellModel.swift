//
//  ImageSearchTableViewCellModel.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/22/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import ReactiveCocoa

class ImagesTableViewCellModel:  ImagesTableViewCellModeling {
    let id: Int
    let text: String
    let previewImageURL : NSURL
    
    internal init(image: ImageEntity) {
        id = image.id
        
        text = "\(image.pageImageWidth) x \(image.pageImageHeight)"
        previewImageURL = image.previewURL
    }
    
}
