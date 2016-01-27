//
//  ImageEntity.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/21/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import Argo
import Curry

struct ImageEntity {
    let id: Int
    
    let pageURL: String
    let pageImageWidth: Int
    let pageImageHeight: Int
    
    let previewURL: NSURL
    let previewWidth: Int
    let previewHeight: Int
    
    let imageURL: String
    let imageWidth: Int
    let imageHeight: Int
    
    let viewCount: Int
    let downloadCount: Int
    let likeCount: Int
    let username: String
}

// MARK: Decodable

extension ImageEntity: Decodable {
    
    
    static func decode(json: JSON) -> Decoded<ImageEntity> {
        
        let a = curry(self.init)
            <^> json <| "id"
            <*> json <| "pageURL"
            <*> json <| "imageWidth"
            
            
        let b = a <*> json <| "imageHeight"
            <*> json <| "previewURL"
            <*> json <| "previewWidth"
            <*> json <| "previewHeight"
       
        
        return b
            <*> json <| "webformatURL"
            <*> json <| "webformatWidth"
            <*> json <| "webformatHeight"
            <*> json <| "views"
            <*> json <| "downloads"
            <*> json <| "likes"
            <*> json <| "user"
    }
}

//
//extension ImageEntity: Decodable {
//    public static func decode(e: Extractor) throws -> ImageEntity {
//        return self
//        
//        
//        return try ImageEntity(
//            id: e <| "id",
//            
//            pageURL: e <| "pageURL",
//            pageImageWidth: e <| "imageWidth",
//            pageImageHeight: e <| "imageHeight",
//            
//            previewURL: e <| "previewURL",
//            previewWidth: e <| "previewWidth",
//            previewHeight: e <| "previewHeight",
//            
//            imageURL: e <| "webformatURL",
//            imageWidth: e <| "webformatWidth",
//            imageHeight: e <| "webformatHeight",
//            
//            viewCount: e <| "views",
//            downloadCount: e <| "downloads",
//            likeCount: e <| "likes",
//            
//            username: e <| "user"
//        )
//    }
//}
