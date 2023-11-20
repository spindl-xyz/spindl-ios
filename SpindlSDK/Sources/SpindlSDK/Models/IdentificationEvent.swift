//
//  IdentificationEvent.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//

import Foundation
import Blackbird

final class IdentificationEvent : Codable, DBArchivable {
    
    
    init(record: EventRecord) throws {
        
    }
    
    func record() throws -> EventRecord {
        throw APIError.notLoggedIn
    }
}
