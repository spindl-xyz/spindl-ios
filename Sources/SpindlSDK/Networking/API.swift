//
//  API.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//

import Foundation
import Combine
import AnyCodable
#if canImport(UIKit)
import UIKit
#endif

enum API {
    static let agent = Agent()
    static let persistentID: String = {
        return setupPersistentID()
    }()
    
    static var baseURL: URL {
        HostManager.shared.url
    }
    
    static var apiKey: String? = setupApiKey() {
        didSet {
            if let ak = apiKey, ak != oldValue {
                UserDefaults.standard.set(value: ak, for: .apiKey)
            }
        }
    }
    
    // Actual public API
    
    static func track<C>(events: [Event<C>]) async -> Result<URLResponse, Error> {
        guard let key = apiKey else {
            return .failure(APIError.missingApiKey)
        }
        
        let url = baseURL.appendingPathComponent("events/mobile")
        
        return await call(url: url, params: events, apiKey: key, method: .post)
    }
    
    // Private implementation details
    
    private static func call<P: Encodable>(url: URL, params: P? = nil, apiKey: String? = nil, method: HTTPMethod = .post, contentType: NetworkingConstants.MimeType = .JSON, encoder: JSONEncoder = Spindl.encoder) async -> Result<URLResponse, Error> {
        var request: URLRequest
        
        if method.acceptsBody {
            request = URLRequest(url: url)
            
            switch contentType {
            case .JSON:
                guard let params = params else {
                    return .failure(APIError.badArgument("params"))
                }
                
                do {
                    try request.setJSONBody(params: params, encoder: encoder) // Sets Content-Type header to JSON
                } catch {
                    return .failure(error)
                }
            default:
                // FIXME/TODO?
                break
            }
        } else if let params = params {
            
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return .failure(APIError.badURL(url))
            }
            
            let queryItems = convertToQueryItems(params)
            
            urlComponents.queryItems = queryItems
            
            guard let fullURL = urlComponents.url else {
                return .failure(APIError.badURL(url))
            }
            
            request = URLRequest(url: fullURL)
        } else {
            request = URLRequest(url: url)
        }
        
        setBasicHeaders(on: &request)
       
        if let apiKey = apiKey, !apiKey.isEmpty {
            request.setApiKey(key: apiKey)
        }
        
        request.httpMethod = method.rawValue
        
        return await agent.run(request)
    }
    
    // MARK: Setup
    
    static fileprivate func encodeParams<E: Encodable>(_ param: E, encoder: JSONEncoder = Spindl.encoder) -> [AnyHashable:Any] {
        if let dict = param as? [AnyHashable:Any] {
            return dict
        }
        
        do {
            let data = try encoder.encode(param)
            
            return try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable:Any] ?? [:]
        } catch {
        }
        
        return [:]
    }
    
    private static func setupApiKey() -> String? {
        if let key: String = UserDefaults.standard.value(for: .apiKey) {
            return key
        }
        
        return nil
    }
    
    private static func setupPersistentID() -> String {
        if let id: String = UserDefaults.standard.value(for: .persistentId) {
            return id
        }
        
#if os(macOS)
        let pid = UUID().uuidString
#else
        let pid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
#endif
        UserDefaults.standard.set(value: pid, for: .persistentId)
        return pid
    }
    
    static fileprivate func convertToQueryItems<E: Encodable>(_ arg: E, excluding: [AnyHashable] = []) -> [URLQueryItem] {
        // FIXME: Add parameter if need a Stripe encoding sometimes..
        let dict = encodeParams(arg).filter({ !excluding.contains($0.key) })
        let queryItems = dict.compactMap { (tuple) -> URLQueryItem in
            let valStr: String
            
            let v: Any
            
            if let ae = tuple.value as? AnyEncodable {
                v = ae.value
            } else {
                v = tuple.value
            }
            
            switch v {
            case let b as Bool:
                valStr = b ? "1" : "0"
            case let a as [String]:
                valStr = a.joined(separator: ",") // FIXME: Should be more like convertArrayToQueryItems???
            default:
                valStr = "\(tuple.value)"
            }
            
            return URLQueryItem(name: "\(tuple.key)", value: valStr)
        }
        
        return queryItems
    }

    static fileprivate func convertArrayToQueryItems(_ arg: [String], named keyName: String) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        for value in arg {
            let qi = URLQueryItem(name: "\(keyName)[]", value: value)
            queryItems.append(qi)
        }
        
        return queryItems
    }
    
    static private func setBasicHeaders(on request: inout URLRequest) {
        request.setValue(NetworkingConstants.MimeType.JSON.rawValue, forHTTPHeaderField: NetworkingConstants.Accept)
    }

}
