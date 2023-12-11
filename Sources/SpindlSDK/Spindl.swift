// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Blackbird

public actor Spindl {
    static public let shared = Spindl()
    internal static let decoder = SpindlJSONDecoder()
    internal static let encoder = SpindlJSONEncoder()
    private let whitespaceRegex = try! Regex("\\s+")
    
    private let db: Blackbird.Database = {
#if DEBUG
        let dbOptions = Blackbird.Database.Options.debugPrintEveryQuery
#else
        let dbOptions: Blackbird.Database.Options = []
#endif
        let db = try! Blackbird.Database(path: EventRecord.dbPath, options: dbOptions)
        return db
    }()
    
    private let uploader: Uploader
    
    private init() {
        uploader = Uploader(db: db)
    }
    
    public static func initialize(apiKey: String) {
        API.apiKey = apiKey
    }
    
    public func identify(walletAddress: String? = nil, customerUserId: String? = nil) async throws  {
        guard let apiKey = API.apiKey, !apiKey.isEmpty else {
            // Something bad...
            throw APIError.missingApiKey
        }
        
        guard nil != walletAddress || nil != customerUserId else {
            throw APIError.missingIdentification
        }
        
        let fixedUpWalletAddress = sanitise(walletAddress: walletAddress)
        
        let record = try makeIdentifyRecord(walletAddress: fixedUpWalletAddress, customerUserId: customerUserId)
        try await record.write(to: db)
    }
    
    public func track<P: Codable>(name: String, properties: P? = nil) async throws {
        guard nil != API.apiKey else {
            throw APIError.missingApiKey
        }
        
        let record = try makeCustomEventRecord(name: name, properties: properties)
        try await record.write(to: db)
    }
    
    // MARK: Private
    
    private func sanitise(walletAddress: String?) -> String? {
        if let addy = walletAddress {
            return addy.replacing(whitespaceRegex, with: "_")
        }
        
        return nil
    }
    
    private func makeIdentifyRecord(walletAddress: String?, customerUserId: String?) throws -> EventRecord {
        let identity = EventIdentity(address: walletAddress, customerUserId: customerUserId)
        
        let identifyEvent = Event<String>(type: .default,
                            data: EventData(name: "IDENTIFY", properties: nil),
                            identity: identity,
                            metadata: MobileSDKMetadata(persistentId: API.persistentID, ts: .now))
        
        return try identifyEvent.record()
    }
    
    private func makeCustomEventRecord<P: Codable>(name: String, properties: P? = nil) throws -> EventRecord {
        let eventData = EventData(name: name, properties: properties)
        let metadata = MobileSDKMetadata(persistentId: API.persistentID, ts: .now)
        let customEvent = Event(type: .custom, data: eventData, metadata: metadata)
        return try customEvent.record()
    }
}
