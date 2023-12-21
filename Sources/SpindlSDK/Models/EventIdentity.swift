//
//  EventIdentity.swift
//
//
//  Created by מאיר רדנוביץ׳ on 19/11/2023.
//

import Blackbird

struct EventIdentity : Codable {
    static func == (lhs: EventIdentity, rhs: EventIdentity) -> Bool {
        true
    }
    
    let address: String?
    let customerUserId: String?
    
    init(address: String? = nil, customerUserId: String? = nil) {
        self.address = address
        self.customerUserId = customerUserId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let addy = address, !addy.isEmpty {
            try container.encode(addy, forKey: .address)
        }
        
        if let userID = customerUserId, !userID.isEmpty {
            try container.encode(userID, forKey: .customerUserId)
        }
    }
}
