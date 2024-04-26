//
//  WebServiceProtocol.swift
//
//
//  Created by Hanan on 26/04/2024.
//

import Foundation
import Alamofire

public enum APIMethod {
    case get
    case post
    case put
    case delete
}

public protocol WebServiceProtocol {
    var path: String { get }
    var headers: [String: String] { get }
    var method: APIMethod { get }
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
