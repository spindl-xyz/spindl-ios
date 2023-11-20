//
//  Event.swift
//
//
//  Created by מאיר רדנוביץ׳ on 19/11/2023.
//

import Foundation
import Blackbird

internal enum EventType: String, BlackbirdStringEnum {
    case custom = "CUSTOM"
    case `default` = "DEFAULT"
}

final class EventRecord : BlackbirdModel {
    static var primaryKey: [BlackbirdColumnKeyPath] = [\.$guid]
    
    @BlackbirdColumn var guid: String
    @BlackbirdColumn var type: EventType
    @BlackbirdColumn var dataName: String
    @BlackbirdColumn var dataProperties: String? // JSON
    @BlackbirdColumn var identityAddress: String?
    @BlackbirdColumn var identityCustomerUserID: String?
    @BlackbirdColumn var metadataPersistentID: String
    @BlackbirdColumn var ts: Date
    
    static func == (lhs: EventRecord, rhs: EventRecord) -> Bool {
        return lhs.guid == rhs.guid &&
        lhs.type == rhs.type &&
        lhs.dataName == rhs.dataName &&
        lhs.dataProperties == rhs.dataProperties &&
        lhs.identityAddress == rhs.identityAddress &&
        lhs.identityCustomerUserID == rhs.identityCustomerUserID &&
        lhs.metadataPersistentID == rhs.metadataPersistentID
    }
    
    init(guid: UUID = UUID(), type: EventType, dataName: String, dataProperties: String? = nil, identityAddress: String? = nil, identityCustomerUserID: String? = nil, metadataPersistentID: String, ts: Date) {
        self.guid = guid.uuidString
        self.type = type
        self.dataName = dataName
        self.dataProperties = dataProperties
        self.identityAddress = identityAddress
        self.identityCustomerUserID = identityCustomerUserID
        self.metadataPersistentID = metadataPersistentID
        self.ts = ts
    }
    
}

struct Event<C: Codable>: Codable, DBArchivable, CustomDebugStringConvertible {
    
    let type: EventType
    let data: EventData<C>
    let identity: EventIdentity?
    var sdkType = "ios_sdk_full"
    let metadata: MobileSDKMetadata
    
    var debugDescription: String {
        "type: \(type), data: \(data.name), identity: \(String(describing: identity)), metadata: \(metadata.ts)"
    }
    
    init(record: EventRecord) throws {
        self.type = record.type
        let props: C?
        if let propString = record.dataProperties {
            props = try Spindl.decoder.decode(C.self, from: propString.d)
        } else {
            props = nil
        }
        
        self.data = EventData(name: record.dataName, properties: props)
        
        if nil != record.identityAddress || nil != record.identityCustomerUserID {
            self.identity = EventIdentity(address: record.identityAddress, customerUserId: record.identityCustomerUserID)
        } else {
            self.identity = nil
        }
        
        self.metadata = MobileSDKMetadata(persistentId: record.metadataPersistentID, ts: record.ts)
    }
    
    init(type: EventType, data: EventData<C>, identity: EventIdentity? = nil, metadata: MobileSDKMetadata) {
        self.type = type
        self.data = data
        self.identity = identity
        self.metadata = metadata
    }
    
    func record() throws -> EventRecord {
        let dataPropertiesJson: String?
        
        if let p = data.properties {
            dataPropertiesJson = try Spindl.encoder.encode(p).s
        } else {
            dataPropertiesJson = nil
        }
        
        return EventRecord(
            type: type,
            dataName: data.name,
            dataProperties: dataPropertiesJson,
            identityAddress: identity?.address,
            identityCustomerUserID: identity?.customerUserId,
            metadataPersistentID: metadata.persistentId,
            ts: metadata.ts
        )
    }
}
