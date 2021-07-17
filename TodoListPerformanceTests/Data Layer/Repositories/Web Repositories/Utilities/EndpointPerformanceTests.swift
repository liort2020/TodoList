//
//  EndpointPerformanceTests.swift
//  TodoListPerformanceTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

final class EndpointPerformanceTests: XCTestCase {
    private let testURL = "https://test.com"
    private var fakeTodo: Todo?
    
    override func setUp() {
        super.setUp()
        fakeTodo = FakeTodoItems.all.first
    }
    
    func test_getAll_performance() throws {
        let testableObject = RealTodoWebRepository.TodoEndpoint.getAll
        
        measure {
            let _ = try? testableObject.request(url: testURL)
        }
    }
    
    func test_addNew_performance() throws {
        let newTodoTitle = "New Title"
        let testableObject = RealTodoWebRepository.TodoEndpoint.addNew(newTodoTitle)

        measure {
            let _ = try? testableObject.request(url: testURL)
        }
    }
    
    func test_delete_performance() throws {
        let todo = try XCTUnwrap(fakeTodo)
        let testableObject = RealTodoWebRepository.TodoEndpoint.deleteItem(todo)

        measure {
            let _ = try? testableObject.request(url: testURL)
        }
    }
    
    override func tearDown() {
        fakeTodo = nil
        super.tearDown()
    }
}
