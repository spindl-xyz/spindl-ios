//
//  NetworkingConstants.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//

import Foundation

enum NetworkingConstants {
    
    enum MimeType : String, CustomStringConvertible {
        case JSON = "application/json"
        case FormData = "multipart/form-data"
        case PNG = "image/png"
        case JPEG = "image/jpeg"
        
        var description: String {
            rawValue
        }
    }
    
    // HTTP Headers
    static let ContentType = "Content-Type"
    static let Authorisation = "Authorization"
    static let ApiKey = "X-Api-Key"
    static let Accept = "Accept"
    static let UserID = "User-Identifier"    

    #if DEBUG
    static let uploadInterval: TimeInterval = 15
    #else
    static let uploadInterval: TimeInterval = 60
    #endif
    
    static let queue = DispatchQueue(label: "xyz.spindl.queue.api", qos: .userInitiated, attributes: [.concurrent], autoreleaseFrequency: .workItem, target: nil)
}

enum Host: Int, CaseIterable
{
    case development = 1
//    case production = 2
    
    var name: String {
        switch self {
        case .development:
            return "Development"
//        case .production:
//            return "Production"
            
        }
    }
    
    var url: String {
        // TODO: Different servers for each environment
        "https://spindl.link"
    }
}

enum HTTPMethod: String
{
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    
    var acceptsBody: Bool {
        switch self {
        case .post, .patch, .put:
            return true
        case .get, .delete:
            return false
        }
    }
}
