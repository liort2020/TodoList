//
//  TodoWebRepositoryTests.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
import CoreData
@testable import TodoList

final class TodoWebRepositoryTests: XCTestCase {
    private let baseUrl = TestWebRepository.testURL
    private static let expectationsTimeOut: TimeInterval = 5.0
    private var inMemoryContainer: NSPersistentContainer?
    private var subscriptions = Set<AnyCancellable>()
    
    private var testableObject: RealTodoWebRepository?
    
    override func setUp() {
        super.setUp()
        inMemoryContainer = InMemoryContainer.container
        testableObject = RealTodoWebRepository(session: .mockedSession, baseURL: baseUrl)
    }
    
    func test_getAll() throws {
        let expectedNumberOfItems = 4
        let expectation = expectation(description: "getAll")
        
        // Given
        let data = try XCTUnwrap(MockedModel.getTodoListData())
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        try XCTUnwrap(testableObject)
            .getAll()
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
    
    func test_store() throws {
        let expectation = expectation(description: "store")
        
        // Given
        let todoTitle = "Bake a cake"
        let data = try XCTUnwrap(MockedModel.todoData())
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        try XCTUnwrap(testableObject)
            .store(title: todoTitle)
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { newTodoWebModel in
                // Then
                XCTAssertNotNil(newTodoWebModel.id, "The item id should not be empty")
                XCTAssertEqual(newTodoWebModel.title, todoTitle, "We got item title: \(newTodoWebModel.title), instead of \(todoTitle)")
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_delete() throws {
        let context = try XCTUnwrap(inMemoryContainer).viewContext
        let expectation = expectation(description: "delete")
        
        // Given
        let todoBeforeDelete = Todo(context: context)
        todoBeforeDelete.id = "372"
        todoBeforeDelete.title = "Bake a cake"
        
        let data = try XCTUnwrap(MockedModel.todoData())
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockWebError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockWebError.response }
            return (response, data)
        }
        
        // When
        try XCTUnwrap(testableObject)
            .delete(todo: todoBeforeDelete)
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
    
    override func tearDown() {
        inMemoryContainer = nil
        testableObject = nil
        subscriptions.removeAll()
        super.tearDown()
    }
}
