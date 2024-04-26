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
    var method: Method { get }
    var headers: [String: String] { get }
}

public enum Method {
    case get
    case post
    case put
    case delete
}
