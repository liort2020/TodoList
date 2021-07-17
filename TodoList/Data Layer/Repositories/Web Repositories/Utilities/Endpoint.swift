//
//  Endpoint.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    
    func body() throws -> Data?
}

extension Endpoint {
    func request(url: String) throws -> URLRequest? {
        guard let urlPath = URL(string: url + path) else { throw WebError.invalidURL }
        
        var urlRequest = URLRequest(url: urlPath)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try body()
        return urlRequest
    }
}

// MARK: - Todo Endpoint
extension RealTodoWebRepository {
    enum TodoEndpoint: Endpoint {
        case getAll
        case addNew(String)
        case deleteItem(Todo)
        
        var path: String {
            switch self {
            case .getAll, .addNew:
                return ""
            case let .deleteItem(todo):
                return "/\(todo.id ?? "")"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getAll:
                return .get
            case .addNew:
                return .post
            case .deleteItem:
                return .delete
            }
        }
        
        var headers: [String : String]? {
            ["Content-Type": "application/json"]
        }
        
        func body() throws -> Data? {
            switch self {
            case let .addNew(title):
                let jsonBody: [String: Any] = ["title": title]
                return try jsonBody.retriveData()
            default:
                return nil
            }
        }
    }
}
