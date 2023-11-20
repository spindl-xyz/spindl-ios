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
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.persistentId = try container.decode(String.self, forKey: .persistentId)
//        
//        if let timestampString = try? container.decode(String.self, forKey: .ts),
//           let double = timestampString.doubleValue {
//            self.ts = Date(timeIntervalSince1970: double * 1000.0)
//        } else {
//            self.ts = try container.decode(Date.self, forKey: .ts)
//        }
//    }
//    
//    enum CodingKeys: CodingKey {
//        case persistentId
//        case ts
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.persistentId, forKey: .persistentId)
//        try container.encode(self.ts, forKey: .ts)
//    }
}
