import XCTest
import AnyCodable
import Blackbird
@testable import SpindlSDK

final class SpindlSDKTests: XCTestCase {
    static let properties: [String:AnyCodable] = ["prop":"eller", "prop2":"swanson", "prop3": 47]
    static let event = Event(type: .custom, data: EventData(name: "blumpy", properties: properties), identity: EventIdentity(address: "shmoopie", customerUserId: "ron@example.com"), metadata: MobileSDKMetadata(persistentId: "superego", ts: Date(timeIntervalSinceNow: -1000000.0)))
    static let identifyEvent = Event(type: .default, data: EventData<String>(name: "IDENTIFY", properties: nil),
               identity: EventIdentity(address: "bob@example.com"),
                                     metadata: MobileSDKMetadata(persistentId: "nothing", ts: .now))
    let spindl = Spindl.shared
    
    override func setUp() async throws {
        Spindl.initialize(apiKey: "<your API key here>")
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
                "persistentId": "ego",
                "appID": "xyz.spindl.example"
            },
            "sdkType": "ios_sdk_full",
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
        let expectation1 = XCTestExpectation(description: "Wrote event 1")
        let expectation2 = XCTestExpectation(description: "Wrote event 2")
        
        do {
            let db = try! Blackbird.Database(path: "/tmp/testInsertEvent.db", options: [.debugPrintEveryQuery])
            let newEvent1 = randomEvent()
            let newEvent2 = randomEvent()
            try await newEvent1.record().write(to: db)
            expectation1.fulfill()
            try await newEvent2.record().write(to: db)
            expectation2.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        await fulfillment(of: [expectation1, expectation2], timeout: 60)
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
    
    func testButtonEvent() async {
        let expectation1 = XCTestExpectation(description: "Tracked event")
        
        do {
            try await Spindl.shared.track(name: "myButtonTapped", properties: ["view":"MyLoginView","otherProperty":"Another one"])
            expectation1.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        await fulfillment(of: [expectation1], timeout: 60)
    }
    
    func testIdentityValidationError() async {
        let badWalletEvent = Event<String>(type: .default,
                             data: EventData(name: "IDENTIFY", properties: nil),
                             identity: EventIdentity(address: "This is not valid"),
                             metadata: MobileSDKMetadata(persistentId: "nothing", ts: Date(timeIntervalSince1970: 1.55)))
        let result = await API.track(events: [badWalletEvent])
        
        switch result {
        case let .success(res):
            XCTFail("This shouldn't happen: \(res)")
        case let .failure(err):
            print("Error, as expected: \(err.localizedDescription)")
        }
    }
    
    func testIdentify() async {
        do {
            try await spindl.identify(walletAddress: "bobo")
            try await spindl.identify(customerUserId: "boba@thebook.example.coffee")
        } catch {
            print("Error: \(error.localizedDescription)")
            XCTFail(error.localizedDescription)
        }
    }
}
