//
//  MobileSDKMetadata.swift
//
//
//  Created by מאיר רדנוביץ׳ on 19/11/2023.
//

import Foundation

struct MobileSDKMetadata : Codable {
    static func == (lhs: MobileSDKMetadata, rhs: MobileSDKMetadata) -> Bool {
        true
    }
    
    let persistentId: String
    let ts: Date
}
