//
//  TodoDBRepositoryTests.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
import CoreData
@testable import TodoList

final class TodoDBRepositoryTests: XCTestCase {
    private var mockedPersistentStore = MockedPersistentStore()
    private var subscriptions = Set<AnyCancellable>()
    private static let expectationsTimeOut: TimeInterval = 5.0
    
    private var testableObject: RealTodoDBRepository?
    
    override func setUp() {
        super.setUp()
        mockedPersistentStore.inMemoryContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        testableObject = RealTodoDBRepository(persistentStore: mockedPersistentStore)
        mockedPersistentStore.verify()
    }
    
    func test_fetchTodoList() throws {
        let context = mockedPersistentStore.inMemoryContainer.viewContext
        let todoWebModels = MockedModel.load()
        
        // Given
        let fetchItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 0)
        mockedPersistentStore.actions = MockedList(expectedActions: [
            .fetch(fetchItemSnapshot)
        ])
        
        let expectation = expectation(description: "fetchTodoList")
        
        // Save items
        save(items: todoWebModels, in: context)
        
        // When
        // Fetch items
        try XCTUnwrap(testableObject)
            .fetchTodoList()
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { todos in
                // Then
                XCTAssertEqual(todoWebModels.count, todos.count, "Fetch \(todos.count) items instead of \(todoWebModels.count) items")
                self.mockedPersistentStore.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: Self.expectationsTimeOut)
    }
    
    func test_fetchTodo() throws {
        let context = mockedPersistentStore.inMemoryContainer.viewContext
        guard let todoWebModel = MockedModel.load().first else {
            XCTFail("Unable to load item")
            return
        }
        
        // Given
        let fetchItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 0)
        mockedPersistentStore.actions = MockedList(expectedActions: [
            .fetch(fetchItemSnapshot)
        ])
        
        let expectation = expectation(description: "fetchTodo")
        
        // Save items
        save(items: [todoWebModel], in: context)
        
        // When
        // Fetch items
        try XCTUnwrap(testableObject)
            .fetchTodo(by: [todoWebModel.id])
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { todos in
                guard let todo = todos.first, let todoId = todo.id else {
                    XCTFail("Could not fetch the item")
                    return
                }
                // Then
                XCTAssertEqual(todoWebModel.id, todoId, "Fetch \(todoId) item id instead of \(todoWebModel.id) item id")
                self.mockedPersistentStore.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: Self.expectationsTimeOut)
    }
    
    func test_storeTodoList() throws {
        let todoWebModels = MockedModel.load()
        
        // Given
        let updateOneItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 1, updatedObjects: 0, deletedObjects: 0)
        mockedPersistentStore.actions = MockedList(expectedActions: [
            .update(updateOneItemSnapshot),
            .update(updateOneItemSnapshot),
            .update(updateOneItemSnapshot),
            .update(updateOneItemSnapshot)
        ])
        
        let expectation = expectation(description: "storeTodoList")
        
        // When
        try XCTUnwrap(testableObject)
            .store(todoList: todoWebModels)
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { todos in
                // Then
                self.mockedPersistentStore.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: Self.expectationsTimeOut)
    }
    
    func test_deleteTodo() throws {
        let context = mockedPersistentStore.inMemoryContainer.viewContext
        let todoWebModels = MockedModel.load()
        
        // Given
        let deleteItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 1)
        let fetchItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 0)
        mockedPersistentStore.actions = MockedList(expectedActions: [
            .fetch(fetchItemSnapshot),
            .delete(deleteItemSnapshot),
            .fetch(fetchItemSnapshot)
        ])
        
        let expectation = expectation(description: "storeTodoList")
        
        // Save items
        save(items: todoWebModels, in: context)
        
        let testableObject = try XCTUnwrap(testableObject)
        
        var todoItemsBeforeDelete = [Todo]()
        var todoIdBeforeDelete = ""
        
        // When
        testableObject
            // Fetch items before delete
            .fetchTodoList()
            // Delete item
            .flatMap { todos -> AnyPublisher<Void, Error> in
                todoItemsBeforeDelete.append(contentsOf: todos)
                todoIdBeforeDelete = todoItemsBeforeDelete[0].id ?? ""
                return testableObject
                    .delete(todo: todoItemsBeforeDelete[0])
            }
            // Fetch items after delete
            .flatMap { () -> AnyPublisher<[Todo], Error> in
                testableObject
                    .fetchTodoList()
            }
            .sink { completion in
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            } receiveValue: { todoItemsAfterDelete in
                // Then
                XCTAssertEqual(todoItemsBeforeDelete.count - 1, todoItemsAfterDelete.count, "Fetch \(todoItemsAfterDelete.count) items instead of \(todoItemsBeforeDelete.count - 1) items")
                
                // Check if the item ID has been deleted
                XCTAssertFalse(todoIdBeforeDelete.isEmpty)
                XCTAssertTrue(!todoItemsAfterDelete.map({ $0.id }).contains(todoIdBeforeDelete), "Item \(todoIdBeforeDelete) has not been deleted")
                
                self.mockedPersistentStore.verify()
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: Self.expectationsTimeOut)
    }
    
    func test_deleteTodo_twice() throws {
        let context = mockedPersistentStore.inMemoryContainer.viewContext
        // Given
        let todo = Todo(context: context)
        todo.id = nil
        
        // We do not expect to receive actions
        mockedPersistentStore.actions = MockedList(expectedActions: [])
        
        let expectation = expectation(description: "deleteTodoTwice")
        
        let testableObject = try XCTUnwrap(testableObject)
        
        // When
        testableObject
            .delete(todo: todo)
            .sink { completion in
                // Then
                if let error = completion.checkError() {
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
                self.mockedPersistentStore.verify()
                expectation.fulfill()
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: Self.expectationsTimeOut)
    }
    
    private func save(items todoWebModels: [TodoWebModel], in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                todoWebModels.forEach {
                    $0.store(in: context)
                }
                
                guard context.hasChanges else {
                    XCTFail("Items not saved")
                    context.reset()
                    return
                }
                try context.save()
            } catch {
                XCTFail("Items not saved")
                context.reset()
            }
        }
    }
    
    override func tearDown() {
        testableObject = nil
        subscriptions.removeAll()
        super.tearDown()
    }
}
