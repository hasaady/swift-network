//
//  NetworkManager.swift
//  
//
//  Created by Hanan on 25/01/2024.
//

import Foundation
import Combine

public class NetworkService: NetworkServiceProtocol {
    
    public init () {}
        
    public func request<T: Decodable>(endpoint: Endpoint, _ responseType: T.Type) async -> Result<T, Error> {
        guard let urlRequest = createRequest(endpoint: endpoint) else {
            return .failure(NetworkError.invalidURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(NetworkError.requestFailed)
            }
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(NetworkError.decodingError)
        }
    }
    
    public func request<T: Decodable>(endpoint: Endpoint, _ responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let urlRequest = createRequest(endpoint: endpoint) else {
            precondition(false, "NetworkError invalidURL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                    throw NetworkError.invalidURL
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                switch error {
                case is DecodingError:
                    return .decodingError
                case let error as NetworkError:
                    return error
                default:
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
    
    fileprivate func createRequest(endpoint: Endpoint) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "\(endpoint.host)/\(endpoint.path)") else {
            return nil
        }
                
        if endpoint.method == .get, let query = endpoint.query {
            urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let url = urlComponents.url else { return nil }
                
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
}

/*
public class NetworkManager {
    
    public init() { }
    
    var cancellables: Set<AnyCancellable> = []
    
    public func fetchData<T: Decodable>(from baseURL: String, with parameters: [String: String?]) async throws -> T {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        urlComponents.queryItems = parameters.compactMap { (key, value) in
            if let value = value {
                return URLQueryItem(name: key, value: value)
            } else {
                return nil
            }
        }
        
        guard let finalURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: finalURL)

        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidStatusCode
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

}

extension NetworkManager {

    public func postData<T: Codable, U: Codable>(to baseURL: String, body: T) async throws -> U {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        guard let finalURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            throw NetworkError.encodingError
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidStatusCode
        }

        let decoder = JSONDecoder()
        return try decoder.decode(U.self, from: data)
    }

}

extension NetworkManager {
    
    func debugPrintRequest(_ request: URLRequest) {
        print("------ REQUEST START ------")
        print("\(request.httpMethod ?? "HTTP METHOD UNKNOWN") \(request.url?.absoluteString ?? "URL UNKNOWN")")
        
        if let headers = request.allHTTPHeaderFields {
            print("HEADERS:")
            for (header, value) in headers {
                print("\(header): \(value)")
            }
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("BODY:")
            print(bodyString)
        }
        print("------ REQUEST END ------")
    }
}
*/
