//
//  WebRepository.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol WebRepository {
    var bgQueue: DispatchQueue { get }
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func requestURL<T>(endpoint: Endpoint) -> AnyPublisher<T, Error> where T: Codable {
        guard let requestURL = try? endpoint.request(url: baseURL) else {
            return Fail(error: WebError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: requestURL)
            .tryMap { (data, response) in
                guard let response = response as? HTTPURLResponse else {
                    throw WebError.noResponse
                }
                
                guard response.isValidStatusCode() else {
                    throw WebError.httpCode(HTTPError(code: response.statusCode))
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .subscribe(on: bgQueue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestURLWithoutReturningData(endpoint: Endpoint) -> AnyPublisher<Void, Error> {
        guard let requestURL = try? endpoint.request(url: baseURL) else {
            return Fail(error: WebError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: requestURL)
            .tryMap { (_, response) in
                guard let response = response as? HTTPURLResponse else {
                    throw WebError.noResponse
                }
                
                guard response.isValidStatusCode() else {
                    throw WebError.httpCode(HTTPError(code: response.statusCode))
                }
            }
            .subscribe(on: bgQueue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
