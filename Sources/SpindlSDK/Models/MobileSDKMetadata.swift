//
//  MobileSDKMetadata.swift
//
//
//  Created by מאיר רדנוביץ׳ on 19/11/2023.
//

import Foundation

struct MobileSDKMetadata : Codable {
    static func == (lhs: MobileSDKMetadata, rhs: MobileSDKMetadata) -> Bool {
        lhs.ts == rhs.ts && lhs.persistentId == rhs.persistentId
    }
    
    let persistentId: String
    let ts: Date
    private(set) var appID: String = Bundle.main.bundleIdentifier!
}
