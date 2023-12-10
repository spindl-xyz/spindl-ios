//
//  EventData.swift
//
//
//  Created by מאיר רדנוביץ׳ on 19/11/2023.
//

import Foundation
import AnyCodable

struct EventData<C: Codable> : Codable {
    let name: String
    let properties: C?
    
    static func == (lhs: EventData, rhs: EventData) -> Bool {
        true
    }
    
    
}
