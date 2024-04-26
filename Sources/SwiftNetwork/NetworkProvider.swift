//
//  NetworkProvider.swift
//
//
//  Created by Hanan on 26/04/2024.
//

import Foundation
import Alamofire

public struct NetworkProvider {
    public let baseURL: String
    
    public func request<T: Codable, U: Codable>(api: WebServiceProtocol, parameters: U? = nil) async throws -> T {
        return try await AF.request(
            baseURL + api.path,
            method: api.AFMethod,
            parameters: parameters,
            encoder: JSONParameterEncoder.prettyPrinted,
            headers: HTTPHeaders(api.headers)
        )
        .serializingDecodable(T.self)
        .value
    }
    
    public func request<U: Codable>(api: WebServiceProtocol, parameters: U? = nil) async throws {
        let result = await AF.request(
            baseURL + api.path,
            method: api.AFMethod,
            parameters: parameters,
            encoder: JSONParameterEncoder.prettyPrinted,
            headers: HTTPHeaders(api.headers)
        )
            .serializingData()
            .result
        
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
