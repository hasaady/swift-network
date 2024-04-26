//
//  WebServiceRequest.swift
//
//
//  Created by Hanan on 26/04/2024.
//

import Foundation
import Alamofire

public extension WebServiceProtocol {
    
    func request<T: Codable, U: Codable>(parameters: U? = nil) async throws -> T {
        return try await AF.request(
            baseURL + path,
            method: AFMethod,
            parameters: parameters,
            encoder: JSONParameterEncoder.prettyPrinted,
            headers: HTTPHeaders(headers)
        )
        .serializingDecodable(T.self)
        .value
    }
    
    func request<U: Codable>(parameters: U? = nil) async throws {
        let result = await AF.request(
            baseURL + path,
            method: AFMethod,
            parameters: parameters,
            encoder: JSONParameterEncoder.prettyPrinted,
            headers: HTTPHeaders(headers)
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

extension WebServiceProtocol {
    var AFMethod: HTTPMethod {
        switch method {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }
}