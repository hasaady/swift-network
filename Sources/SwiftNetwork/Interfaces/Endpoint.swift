//
//  Endpoint.swift
//  
//
//  Created by Hanan on 26/01/2024.
//

import Foundation

public protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
}
