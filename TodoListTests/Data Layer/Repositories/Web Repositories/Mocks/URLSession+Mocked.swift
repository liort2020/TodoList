//
//  URLSession+Mocked.swift
//  TodoListTests
//
//  Created by Lior Tal on 22/03/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

extension URLSession {
    static var mockedSession: URLSession {
        let configuration: URLSessionConfiguration = .default
        
        
        // TODO: - Add this !!!!!!!!!!
//        configuration.protocolClasses = [RequestMocking.self, RequestBlocking.self]
        
        
        configuration.protocolClasses = [URLProtocolMock.self]
        
        // TODO: - Add this !!!!!!!!!!
//        configuration.timeoutIntervalForRequest = 1
//        configuration.timeoutIntervalForResource = 1
        
        
        return URLSession(configuration: configuration)
    }
}

// MARK: - URLProtocolMock
final class URLProtocolMock: URLProtocol {
    static var testDictionary = [URL: Data]()
    
    // This method determines whether this protocol can handle the given request.
    override class func canInit(with request: URLRequest) -> Bool {
        // True if the protocol can handle the given request, False if not.
        true
    }
    
    // This method returns a canonical version of the given request.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Send back what we received
        request
    }
    
    // Starts protocol-specific loading of a request.
    override func startLoading() {
        if let url = request.url {
            // Check if we have test data for the URL
            guard let data = URLProtocolMock.testDictionary[url] else { return }
            // Tells the client that the protocol implementation has loaded some data.
            client?.urlProtocol(self, didLoad: data)
        }
        
        // Tells the client that the protocol implementation has finished loading.
        client?.urlProtocolDidFinishLoading(self)
    }
    
    
    /*
     override func startLoading() {
         DispatchQueue(label: "").async {
             self.client?.urlProtocol(self, didFailWithError: Error.requestBlocked)
         }
     }
     */
    
    
    
    // TODO: - check if we need stopLoading() !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    // Stops protocol-specific loading of a request.
    override func stopLoading() { }
}
