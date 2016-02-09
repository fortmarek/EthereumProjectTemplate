////
////  NetworkError.swift
////  SwinjectMVVMExample
////
////  Created by Yoichi Tagaya on 8/22/15.
////  Copyright © 2015 Swinject Contributors. All rights reserved.
////
//
//import Foundation
//
//public enum NetworkError: NSError, CustomStringConvertible {
//    /// Unknown or not supported error.
//    case Unknown
//
//    /// Not connected to the internet.
//    case NotConnectedToInternet
//
//    /// International data roaming turned off.
//    case InternationalRoamingOff
//
//    /// Unauthorized by server
//    case Unauthorized
//
//    /// Cannot reach the server.
//    case NotReachedServer
//
//    /// Bad Request
//    case BadRequest
//
//    /// Server Error
//    case ServerError
//
//    /// Connection is lost.
//    case ConnectionLost
//
//    /// Incorrect data returned from the server.
//    case IncorrectDataReturned
//
//    internal init(response: NSHTTPURLResponse?) {
//        guard let response = response else{
//            self = .NotReachedServer
//            return
//        }
//
//        if (response.statusCode ==  401){
//            self = .Unauthorized
//        }else if  (400..<500).contains(response.statusCode) {
//            self = .BadRequest
//        }else if  (500..<600).contains(response.statusCode) {
//            self = .ServerError
//        }else{
//            self = .Unknown
//        }
//    }
//
//        /*
//
//            switch error.code {
//            case NSURLErrorUnknown:
//                self = .Unknown
//            case NSURLErrorCancelled:
//                self = .Unknown // Cancellation is not used in this project.
//            case NSURLErrorBadURL:
//                self = .IncorrectDataReturned // Because it is caused by a bad URL returned in a JSON response from the server.
//            case NSURLErrorTimedOut:
//                self = .NotReachedServer
//            case NSURLErrorUnsupportedURL:
//                self = .IncorrectDataReturned
//            case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
//                self = .NotReachedServer
//            case NSURLErrorDataLengthExceedsMaximum:
//                self = .IncorrectDataReturned
//            case NSURLErrorNetworkConnectionLost:
//                self = .ConnectionLost
//            case NSURLErrorDNSLookupFailed:
//                self = .NotReachedServer
//            case NSURLErrorHTTPTooManyRedirects:
//                self = .Unknown
//            case NSURLErrorResourceUnavailable:
//                self = .IncorrectDataReturned
//            case NSURLErrorNotConnectedToInternet:
//                self = .NotConnectedToInternet
//            case NSURLErrorRedirectToNonExistentLocation, NSURLErrorBadServerResponse:
//                self = .IncorrectDataReturned
//            case NSURLErrorUserCancelledAuthentication, NSURLErrorUserAuthenticationRequired:
//                self = .Unknown
//            case NSURLErrorZeroByteResource, NSURLErrorCannotDecodeRawData, NSURLErrorCannotDecodeContentData:
//                self = .IncorrectDataReturned
//            case NSURLErrorCannotParseResponse:
//                self = .IncorrectDataReturned
//            case NSURLErrorInternationalRoamingOff:
//                self = .InternationalRoamingOff
//            case NSURLErrorCallIsActive, NSURLErrorDataNotAllowed, NSURLErrorRequestBodyStreamExhausted:
//                self = .Unknown
//            case NSURLErrorFileDoesNotExist, NSURLErrorFileIsDirectory:
//                self = .IncorrectDataReturned
//            case
//            NSURLErrorNoPermissionsToReadFile,
//            NSURLErrorSecureConnectionFailed,
//            NSURLErrorServerCertificateHasBadDate,
//            NSURLErrorServerCertificateUntrusted,
//            NSURLErrorServerCertificateHasUnknownRoot,
//            NSURLErrorServerCertificateNotYetValid,
//            NSURLErrorClientCertificateRejected,
//            NSURLErrorClientCertificateRequired,
//            NSURLErrorCannotLoadFromNetwork,
//            NSURLErrorCannotCreateFile,
//            NSURLErrorCannotOpenFile,
//            NSURLErrorCannotCloseFile,
//            NSURLErrorCannotWriteToFile,
//            NSURLErrorCannotRemoveFile,
//            NSURLErrorCannotMoveFile,
//            NSURLErrorDownloadDecodingFailedMidStream,
//            NSURLErrorDownloadDecodingFailedToComplete:
//                self = .Unknown
//            default:
//                self = .Unknown
//            }
//        }
//        else {
//            self = .Unknown
//        }*/
//
//
//    public var description: String {
//        let text: String
//        switch self {
//        case Unknown:
//            text = NSLocalizedString("NetworkError_Unknown", comment: "Error description")
//        case NotConnectedToInternet:
//            text = NSLocalizedString("NetworkError_NotConnectedToInternet", comment: "Error description")
//        case InternationalRoamingOff:
//            text = NSLocalizedString("NetworkError_InternationalRoamingOff", comment: "Error description")
//        case NotReachedServer:
//            text = NSLocalizedString("NetworkError_NotReachedServer", comment: "Error description")
//        case ConnectionLost:
//            text = NSLocalizedString("NetworkError_ConnectionLost", comment: "Error description")
//        case IncorrectDataReturned:
//            text = NSLocalizedString("NetworkError_IncorrectDataReturned", comment: "Error description")
//        case .Unauthorized:
//            text = NSLocalizedString("NetworkError_Unauthorized", comment: "Error description")
//        case .BadRequest:
//            text = NSLocalizedString("NetworkError_BadRequest", comment: "Error description")
//        case .ServerError:
//            text = NSLocalizedString("NetworkError_ServerError", comment: "Error description")
//        }
//
//        return text
//    }
//}