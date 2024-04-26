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
    var headers: [String: String] { get }
    var method: APIMethod { get }
}

public enum APIMethod {
    case get
    case post
    case put
    case delete
}
