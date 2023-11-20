//
//  EventDB.swift
//
//
//  Created by מאיר רדנוביץ׳ on 19/11/2023.
//

import Blackbird
import Foundation

internal class EventDB {
    private let db: Blackbird.Database
    
    init(url: URL) throws {
        db = try Blackbird.Database(path: url.path)
    }
    
//    func getNextID() async throws -> Int64 {
//        let row = try await EventRecord.query(in: db, "SELECT MAX(id) as max FROM $T")
//        return row["max"] + 1
//    }
    
//    func write<C: Codable>(event: Event<C>) async throws {
//        let record = try event.record()
//        
//        try await EventRecord.query(in: db, "INSERT ")
//    }
}

//extension BlackbirdModel {
//    func getNextID(in db: Blackbird.Database) async throws -> Int64 {
//        let row = try await Self.query(in: db, "SELECT MAX(id) as max FROM $T")
//        let max = row.first?["max"]?.int64Value ?? 0
//        return max + 1
//    }
//}
