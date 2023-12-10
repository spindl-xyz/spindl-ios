//
//  URLRequestHelpers.swift
//
//  Created by Meir Radnovich on 2 Shevat 5781.
//

import Foundation
import AnyCodable

extension URLRequest {
    mutating func setJSONBody<E: Encodable>(params: E, encoder: JSONEncoder) throws {
        let data = try encoder.encode(params)
        
        httpBody = data
        setValue(NetworkingConstants.MimeType.JSON.rawValue, forHTTPHeaderField: NetworkingConstants.ContentType)
    }
    
    mutating func setApiKey(key: String) {
        guard !key.isEmpty else {
            return
        }
        
        setValue(key, forHTTPHeaderField: NetworkingConstants.ApiKey)
    }
    
    mutating func setBearerToken(token: String) {
        guard !token.isEmpty else {
            return
        }
        
        setValue("Bearer \(token)", forHTTPHeaderField: NetworkingConstants.Authorisation)
    }
    
    
}
