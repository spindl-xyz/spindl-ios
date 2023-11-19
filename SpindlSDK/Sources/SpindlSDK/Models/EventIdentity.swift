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
}
