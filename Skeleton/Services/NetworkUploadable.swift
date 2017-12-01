//
//  NetworkUploadable.swift
//  Skeleton
//
//  Created by Jakub Olejník on 01/12/2017.
//

import UIKit
import Alamofire
import ACKategories

protocol NetworkUploadable {
    func append(multipart: MultipartFormData)
}

struct PrimitiveUploadable: NetworkUploadable {
    typealias Value = CustomStringConvertible
    
    let key: String
    let value: Value?
    
    func append(multipart: MultipartFormData) {
        guard let value = value, let dataValue = value.description.data(using: .utf8) else { return }
        multipart.append(dataValue, withName: key)
    }
}

struct ImageUploadable: NetworkUploadable {
    let key: String
    let fileName: String
    let mimeType: String
    let image: UIImage
    
    static let maxDimension: CGFloat = 1_024
    static let compressionQuality: CGFloat = 0.95
    
    func append(multipart: MultipartFormData) {
        guard let resizedImage = image.fixedOrientation().resized(maxDimension: ImageUploadable.maxDimension), let imageData = UIImageJPEGRepresentation(resizedImage, ImageUploadable.compressionQuality) else { return }
        multipart.append(imageData, withName: key, fileName: fileName, mimeType: mimeType)
    }
}
