import XCTest
import AnyCodable
@testable import SpindlSDK

final class SpindlSDKTests: XCTestCase {
    func testEncode() throws {
        let properties: [String:AnyCodable] = ["prop":"eller", "prop2":"swanson", "prop3": 47]
        let event = Event(type: .custom, data: EventData(name: "blumpy", properties: properties), identity: EventIdentity(address: "shmoopie", customerUserId: "ron@example.com"), metadata: MobileSDKMetadata(persistentId: "superego", ts: Date(timeIntervalSinceNow: -1000000.0)))
        
        let json = try Spindl.encoder.encode(event)
        
        print(json.s)
        
        XCTAssert(true)
    }
    
    
}
