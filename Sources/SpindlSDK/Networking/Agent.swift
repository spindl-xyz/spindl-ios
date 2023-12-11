//
//  Agent.swift
//
//
//  Created by מאיר רדנוביץ׳ on 20/11/2023.
//  Based on https://www.vadimbulavin.com/modern-networking-in-swift-5-with-urlsession-combine-framework-and-codable/
//
//

import Foundation
import Combine

struct Response<T> {
    let value: T
    let response: HTTPURLResponse
}

struct Agent {

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300
        return URLSession(configuration: config)
    }()
    
    func parse<T: Decodable>(data: Data, usingDecoder decoder: JSONDecoder) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) async -> Result<Response<T>, Error> {
        do {
            let (data, response) = try await session.data(for: request)
            let res: T = try parse(data: data, usingDecoder: decoder)
            
            return .success(Response(value: res, response: response as! HTTPURLResponse))
        } catch {
            return .failure(error)
        }
    }
    
    func run(_ request: URLRequest) async -> Result<URLResponse, Error> {
        do {
            let (data, response) = try await session.data(for: request)
            
            if data.isEmpty {
                return .success(response)
            }
            
            return .failure(APIError.serverError(data.s))
        } catch {
            return .failure(error)
        }
    }
}
