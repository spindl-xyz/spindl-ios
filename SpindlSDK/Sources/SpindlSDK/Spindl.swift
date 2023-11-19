// The Swift Programming Language
// https://docs.swift.org/swift-book

public class Spindl {
    internal static let decoder = SpindlJSONDecoder()
    internal static let encoder = SpindlJSONEncoder()
    
    // suspend fun identify(apiKey: String, walletAddress: String? = null, customerUserId: String? = null):
    public func identify(apiKey: String, walletAddress: String? = nil, customerUserId: String? = nil) async -> [Int] {
        []
    }
    
    public func track<P: Codable>(name: String, properties: P? = nil) async -> [Int] {
        []
    }
}
