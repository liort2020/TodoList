//
//  EndpointTests.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

final class EndpointTests: XCTestCase {
    private var fakeTodo: Todo?
    private var testURL = TestWebRepository.testURL
    
    private var testableObject: RealTodoWebRepository.TodoEndpoint?
    
    override func setUp() {
        super.setUp()
        fakeTodo = FakeTodoItems.all.first
    }
    
    func test_getAll() throws {
        // Given
        let testableObject = try XCTUnwrap(RealTodoWebRepository.TodoEndpoint.getAll)
        
        do {
            // When
            let urlRequest = try testableObject.request(url: testURL)
            
            // Then
            XCTAssertNotNil(urlRequest)
            // path
            let request = try XCTUnwrap(urlRequest)
            XCTAssertNotNil(request.url)
            XCTAssertEqual(request.url?.path, "")
            // method
            XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
            // headers
            XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/json"])
            // body
            XCTAssertNil(request.httpBody)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_addNew() throws {
        // Given
        let newTodoTitle = "New Title"
        let testableObject = try XCTUnwrap(RealTodoWebRepository.TodoEndpoint.addNew(newTodoTitle))
        
        do {
            // When
            let urlRequest = try testableObject.request(url: testURL)
            
            // Then
            XCTAssertNotNil(urlRequest)
            // path
            let request = try XCTUnwrap(urlRequest)
            XCTAssertNotNil(request.url)
            XCTAssertEqual(request.url?.path, "")
            // method
            XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
            // headers
            XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/json"])
            // body
            let httpBody = try XCTUnwrap(request.httpBody)
            XCTAssertNotNil(httpBody)
            XCTAssertFalse(httpBody.isEmpty)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_delete() throws {
        // Given
        let todo = try XCTUnwrap(fakeTodo)
        let todoId = try XCTUnwrap(todo.id)
        let testableObject = try XCTUnwrap(RealTodoWebRepository.TodoEndpoint.deleteItem(todo))
        
        do {
            // When
            let urlRequest = try testableObject.request(url: testURL)
            
            // Then
            XCTAssertNotNil(urlRequest)
            // path
            let request = try XCTUnwrap(urlRequest)
            XCTAssertNotNil(request.url)
            XCTAssertEqual(request.url?.path, "/\(todoId)")
            // method
            XCTAssertEqual(request.httpMethod, HTTPMethod.delete.rawValue)
            // headers
            XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/json"])
            // body
            XCTAssertNil(request.httpBody)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_invalidPath() throws {
        // Given
        let todoWithoutId = try XCTUnwrap(FakeTodoItems.all.filter {
            guard $0.id == "175" else { return false }
            $0.id = nil
            return true
        }.first)
        
        let testableObject = try XCTUnwrap(RealTodoWebRepository.TodoEndpoint.deleteItem(todoWithoutId))
        
        do {
            // When
            let urlRequest = try testableObject.request(url: testURL)
            
            // Then
            XCTAssertNotNil(urlRequest)
            // path
            let request = try XCTUnwrap(urlRequest)
            XCTAssertNotNil(request.url)
            XCTAssertEqual(request.url?.path, "/")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_invalidURL() throws {
        // Given
        let invalidURL = ""
        let testableObject = try XCTUnwrap(RealTodoWebRepository.TodoEndpoint.getAll)
        
        do {
            // When
            let _ = try testableObject.request(url: invalidURL)
            
            XCTFail("Expected a WebError.invalidURL error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error.localizedDescription, WebError.invalidURL.localizedDescription, "Expected an invalidURL error, and got: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        fakeTodo = nil
        testableObject = nil
        super.tearDown()
    }
}
