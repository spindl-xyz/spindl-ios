//
//  Uploader.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//

import Foundation
import Blackbird
import AnyCodable
import Combine

actor Uploader {
    private let db: Blackbird.Database
    private lazy var taskmaster = RepeatingTaskmaster(timeInterval: NetworkingConstants.uploadInterval, callback: upload)
    private var dbChangeListener: AnyCancellable?
    private var inProgress = false
    
    init(db: Blackbird.Database) {
        self.db = db
        
        Task {
            await setDBChangeListener(listener: db.changePublisher(for: EventRecord.tableName)
                .sink { change in
                    Task {
                        await self.receivedDbChange(change: change)
                    }
                })
            
            await taskmaster.resume()
        }
    }
    
    private func receivedDbChange(change: Blackbird.Change) {
        guard !inProgress else { return }
        
        Task {
            await taskmaster.resume()
        }
    }
    
    private func setDBChangeListener(listener: AnyCancellable) {
        dbChangeListener = listener
    }
    
    private func clear<T: BlackbirdModel>(table: T.Type) async throws {
        try await T.query(in: db, "DELETE FROM $T")
    }
    
    private func upload() async {
        guard !inProgress else {
            return
        }
        
        inProgress = true
        
        defer {
            inProgress = false
        }
        
        do {
            let allEvents = try await EventRecord.read(from: db).map( { try Event<AnyCodable>(record: $0) })
            
            guard !allEvents.isEmpty else {
                return
            }
            
            let result = await API.track(events: allEvents)
            
            switch result {
            case let .success(res):
                print("Upload Success: \(res)")
                try await clear(table: EventRecord.self)
                await taskmaster.suspend()
            case let .failure(err):
                print("Upload Failure: \(err)")
            }
        } catch {
            print("Failure: \(error)")
        }
    }
}
