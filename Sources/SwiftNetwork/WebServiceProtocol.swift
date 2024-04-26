//
//  WebServiceProtocol.swift
//
//
//  Created by Hanan on 26/04/2024.
//

import Foundation

public protocol WebServiceProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
}

public enum HTTPMethod {
    case get
    case post
    case put
    case delete
}
