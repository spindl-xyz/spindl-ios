//
//  Uploader.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//

import Foundation
import Blackbird
import AnyCodable

actor Uploader {
    private let db: Blackbird.Database
    private let taskmaster = RepeatingTaskmaster(timeInterval: NetworkingConstants.uploadInterval)
    
    init(db: Blackbird.Database) {
        self.db = db
        
        Task {
            await taskmaster.setEventHandler(upload)
        }
    }
    
    private func upload() async {
        do {
            let allEvents = try await EventRecord.read(from: db).map( { try Event<AnyCodable>(record: $0) })
            
            let result = await API.track(events: allEvents)
            
            switch result {
            case let .success(res):
                print("Upload Success: \(res)")
                try await EventRecord.query(in: db, "DELETE FROM $T")
            case let .failure(err):
                print("Upload Failure: \(err)")
            }
        } catch {
            print("Failure: \(error)")
        }
    }
}
