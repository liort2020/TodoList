//
//  WebRepositoryTests.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import TodoList

final class WebRepositoryTests: XCTestCase {
    private var todoEndpoint: RealTodoWebRepository.TodoEndpoint?
    private var subscriptions = Set<AnyCancellable>()
    private static let expectationsTimeOut: TimeInterval = 5.0
    
    private var testableObject: TestWebRepository?
    
    override func setUp() {
        super.setUp()
        todoEndpoint = RealTodoWebRepository.TodoEndpoint.getAll
        testableObject = TestWebRepository()
    }
    
    func test_requestURL() throws {
        let expectation = expectation(description: "requestURL")
        let expectedNumberOfItems = 4
        
        // Given
        let endpoint = try XCTUnwrap(todoEndpoint)
        let data = try XCTUnwrap(MockedModel.getTodoListData())
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        let publisher: AnyPublisher<[TodoWebModel], Error> = try XCTUnwrap(testableObject).requestURL(endpoint: endpoint)
        publisher
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { todoWebModels in
                // Then
                XCTAssertEqual(todoWebModels.count, expectedNumberOfItems, "Receive \(todoWebModels.count) items instead of \(expectedNumberOfItems) items")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_requestURL_webError_invalidStatusCode() throws {
        let expectation = expectation(description: "requestURL_invalidStatusCode")
        
        // Given
        let invalidStatusCode = 199
        let endpoint = try XCTUnwrap(todoEndpoint)
        let data = try XCTUnwrap(MockedModel.getTodoListData())
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: invalidStatusCode, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        let publisher: AnyPublisher<[TodoWebModel], Error> = try XCTUnwrap(testableObject).requestURL(endpoint: endpoint)
        publisher
            .sink { completion in
                if let error = completion.checkError() {
                    // Then
                    XCTAssertEqual(error.localizedDescription, WebError.httpCode(HTTPError(code: invalidStatusCode)).localizedDescription, "Expected to get invalid status code, and got: \(error.localizedDescription)")
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("Expected to get a WebError")
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_requestURL_withoutReturningData() throws {
        let expectation = expectation(description: "requestURL_withoutReturningData")
        
        // Given
        let endpoint = try XCTUnwrap(todoEndpoint)
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, nil)
        }
        
        // When
        try XCTUnwrap(testableObject)
            .requestURLWithoutReturningData(endpoint: endpoint)
            .sink { completion in
                // Then
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
                expectation.fulfill()
                
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_requestURL_withoutReturningData_webError_invalidStatusCode() throws {
        let expectation = expectation(description: "requestURL_withoutReturningData_invalidStatusCode")
        
        // Given
        let invalidStatusCode = 199
        let endpoint = try XCTUnwrap(todoEndpoint)
        let data = try XCTUnwrap(MockedModel.getTodoListData())
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: invalidStatusCode, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        try XCTUnwrap(testableObject)
            .requestURLWithoutReturningData(endpoint: endpoint)
            .sink { completion in
                if let error = completion.checkError() {
                    // Then
                    XCTAssertEqual(error.localizedDescription, WebError.httpCode(HTTPError(code: invalidStatusCode)).localizedDescription, "Expected to get invalid status code, and got: \(error.localizedDescription)")
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("Expected to get a WebError")
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    override func tearDown() {
        todoEndpoint = nil
        testableObject = nil
        subscriptions.removeAll()
        super.tearDown()
    }
}
