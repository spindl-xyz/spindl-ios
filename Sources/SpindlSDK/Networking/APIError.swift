//
//  APIError.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//

import Foundation


enum APIError : Error, LocalizedError {
    case notLoggedIn
    case badArgument(String)
    case badURL(URL)
    case unknownError(Error)
    case serverError(String)
    case missingApiKey
    case missingIdentification
    
    init(error: Error) {
        switch error {
        case let api as APIError:
            self = api
        default:
            self = .unknownError(error)
        }
    }
    
    var errorDescription: String? {
        switch self {
        case let .unknownError(err):
            return err.localizedDescription
        case .notLoggedIn:
            return "Not Logged In"
        case let .badArgument(errorMessage):
            return errorMessage
        case let .badURL(url):
            return "Couldn't get the components from \(url.absoluteString)"
        case let .serverError(errorMessage):
            return errorMessage
        case .missingApiKey:
            return "Need to call identify with an API key before tracking events"
        case .missingIdentification:
            return "Either wallet address or customer user ID (e.g. email) is required"
        }
    }
}
