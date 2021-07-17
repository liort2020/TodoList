//
//  TodoInteractorTests.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import TodoList

final class TodoInteractorTests: XCTestCase {
    private let appState = CurrentValueSubject<AppState, Never>(AppState())
    private lazy var mockedTodoWebRepository = MockedTodoWebRepository()
    private lazy var mockedTodoDBRepository = MockedTodoDBRepository()
    private lazy var fakeTodos = FakeTodoItems.all
    private static let expectationsTimeOut: TimeInterval = 5.0
    private var subscriptions = Set<AnyCancellable>()
    
    var testableObject: RealTodoInteractor?
    
    override func setUp() {
        super.setUp()
        appState.value = AppState()
        testableObject = RealTodoInteractor(todoWebRepository: mockedTodoWebRepository,
                                            todoDBRepository: mockedTodoDBRepository,
                                            appState: appState)
    }
    
    func test_load() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "load")
        
        // Given
        mockedTodoWebRepository.actions = MockedList(expectedActions: [])
        
        mockedTodoDBRepository.actions = MockedList(expectedActions: [
            .fetchTodoList
        ])
        
        let todosWrapper = MockedBindingWithPublisher(value: [Todo]())
        
        // When
        testableObject
            .load(todoList: todosWrapper.binding)
        
        todosWrapper.publisher
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // Then
                self.mockedTodoWebRepository.verify()
                self.mockedTodoDBRepository.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_fetchAll() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "fetchAll")
        
        // Given
        mockedTodoWebRepository.actions = MockedList(expectedActions: [
            .getAll
        ])
        
        mockedTodoDBRepository.actions = MockedList(expectedActions: [])
        
        let todosWrapper = MockedBindingWithPublisher(value: [Todo]())
        
        // When
        testableObject
            .fetchAll(todoList: todosWrapper.binding)
        
        todosWrapper.publisher
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // Then
                self.mockedTodoWebRepository.verify()
                self.mockedTodoDBRepository.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_store() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "update")
        
        // Given
        let todosWrapper = MockedBindingWithPublisher(value: fakeTodos)
        
        let todoNewTitle = "My Title"
        
        mockedTodoWebRepository.actions = MockedList(expectedActions: [
            .store(title: todoNewTitle)
        ])
        
        mockedTodoDBRepository.actions = MockedList(expectedActions: [])
        
        // When
        testableObject
            .store(title: todoNewTitle, todoList: todosWrapper.binding)
        
        todosWrapper.publisher
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // Then
                self.mockedTodoWebRepository.verify()
                self.mockedTodoDBRepository.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    func test_delete() throws {
        let testableObject = try XCTUnwrap(testableObject)
        let expectation = expectation(description: "delete")
        
        // Given
        let todosWrapper = MockedBindingWithPublisher(value: fakeTodos)
        
        let todoId = "176"
        let todoForDeletion = try XCTUnwrap(fakeTodos.filter { $0.id == todoId }.first)
        
        mockedTodoWebRepository.actions = MockedList(expectedActions: [
            .delete(todo: todoForDeletion)
        ])
        
        mockedTodoDBRepository.actions = MockedList(expectedActions: [])
        
        // When
        testableObject
            .delete(todo: todoForDeletion, todoList: todosWrapper.binding)
        
        todosWrapper.publisher
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                // Then
                self.mockedTodoWebRepository.verify()
                self.mockedTodoDBRepository.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: Self.expectationsTimeOut)
    }
    
    override func tearDown() {
        testableObject = nil
        subscriptions.removeAll()
        super.tearDown()
    }
}
