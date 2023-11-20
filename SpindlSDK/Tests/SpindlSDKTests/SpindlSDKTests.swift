import XCTest
import AnyCodable
import Blackbird
@testable import SpindlSDK

final class SpindlSDKTests: XCTestCase {
    static let properties: [String:AnyCodable] = ["prop":"eller", "prop2":"swanson", "prop3": 47]
    static let event = Event(type: .custom, data: EventData(name: "blumpy", properties: properties), identity: EventIdentity(address: "shmoopie", customerUserId: "ron@example.com"), metadata: MobileSDKMetadata(persistentId: "superego", ts: Date(timeIntervalSinceNow: -1000000.0)))
    
    override func setUp() async throws {
//        API.apiKey = "484c7809-5fe6-4928-a28e-2180b08eea0c"
        API.apiKey = "9662ea01-769c-4a5b-8126-9e2647493846"
    }
    
    private func randomEvent() -> Event<[String:String]> {
        let dataName = String.random(of: 10)
        let props = [String.random(of: 9):String.random(of: 7)]
        let eventData = EventData(name: dataName, properties: props)
        let identity = EventIdentity(address: String.random(of: 22), customerUserId: "\(String.random(of: 6))@\(String.random(of: 9)).\(String.random(of: 3))".lowercased())
        let metadata = MobileSDKMetadata(persistentId: String.random(of: 12), ts: Date(timeIntervalSinceNow: Double.random(in: -340000000.0 ... -9.0)))
        return Event(type: .custom, data: eventData, identity: identity, metadata: metadata)
    }
    
    func testEncode() throws {
        let json = try Spindl.encoder.encode(SpindlSDKTests.event)
        
        print(json.s)
        
        XCTAssert(true)
    }
    
    func testDecode() throws {
        let json = """
        {
            "id": 23456,
            "data": {
                "name": "goofus",
                "properties": 99
            },
            "identity": {
                "address": "lumpawarooWallet",
                "customerUserId": "booya@example.com"
            },
            "metadata": {
                "ts": 1700430547,
                "persistentId": "ego"
            },
            "sdkType": "android_sdk_full",
            "type": "CUSTOM"
        }
"""
        do {
            let event = try Spindl.decoder.decode(Event<AnyCodable>.self, from: json.d)
            
            print(event)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testConvertToRecord() async {
        do {
            let record = try SpindlSDKTests.event.record()
            print(record)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testInsertEvent() async {
        
        do {
            let db = try! Blackbird.Database(path: "/tmp/testInsertEvent.db", options: [.debugPrintEveryQuery])
            let newEvent1 = randomEvent()
            let newEvent2 = randomEvent()
            try await newEvent1.record().write(to: db)
            try await newEvent2.record().write(to: db)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testUploadEvent() async {
        let event = randomEvent()
        let result = await API.track(events: [event])
        
        switch result {
        case let .success(response):
            print("Success: \(response)")
        case let .failure(err):
            XCTFail(err.localizedDescription)
        }
    }
}
