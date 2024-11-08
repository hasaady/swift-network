//
//  NetworkManager.swift
//  Evently
//
//  Created by Hanan Alasady on 01/11/2024.
//

import Foundation

public protocol NetworkProviderProtocol {
    func get<T: Decodable>(path: String) async throws -> T
    func post<T: Decodable, U: Encodable>(path: String, body: U) async throws -> T
    var baseURL: String { get }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}

class NetworkProviderImp: NetworkProviderProtocol {
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func get<T: Decodable>(path: String) async throws -> T {
        let urlString = baseURL.appending(path)
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard
            let httpResponse = response as? HTTPURLResponse,
            200...299 ~= httpResponse.statusCode
        else {
            throw NetworkError.invalidResponse
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    func post<T: Decodable, U: Encodable>(path: String, body: U) async throws -> T {
        
        let urlString = baseURL.appending(path)
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard
            let httpResponse = response as? HTTPURLResponse,
            200...299 ~= httpResponse.statusCode
        else {
            throw NetworkError.invalidResponse
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
