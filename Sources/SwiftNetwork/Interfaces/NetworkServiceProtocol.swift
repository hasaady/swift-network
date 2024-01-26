//
//  NetworkServiceProtocol.swift
//
//
//  Created by Hanan on 26/01/2024.
//

import Foundation
import Combine

public protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: Endpoint, _ responseType: T.Type) async -> Result<T, Error>
    func request<T: Decodable>(endpoint: Endpoint, _ responseType: T.Type) -> AnyPublisher<T, Error>
}
