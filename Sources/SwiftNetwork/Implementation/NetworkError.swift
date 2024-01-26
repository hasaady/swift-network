//
//  NetworkError.swift
//  
//
//  Created by Hanan on 26/01/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode
    case encodingError
    case requestFailed
    case decodingError
    case unknown
}
