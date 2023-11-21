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
    private lazy var taskmaster = RepeatingTaskmaster(timeInterval: NetworkingConstants.uploadInterval, callback: upload)
    
    init(db: Blackbird.Database) {
        self.db = db
        
        Task {
            await taskmaster.resume()
        }
    }
    
    private func upload() async {
        do {
            let allEvents = try await EventRecord.read(from: db).map( { try Event<AnyCodable>(record: $0) })
            
            guard !allEvents.isEmpty else {
                return
            }
            
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
