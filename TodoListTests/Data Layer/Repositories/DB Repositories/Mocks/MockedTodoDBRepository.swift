//
//  MockedTodoDBRepository.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import TodoList

final class MockedTodoDBRepository: Mock, TodoDBRepository {
    enum Action: Equatable {
        case fetchTodoList
        case fetchTodoByIds
        case store(todoList: [TodoWebModel])
        case delete(todo: Todo)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var fetchTodoListResult: Result<[Todo], Error> = .failure(MockedError.valueNeedToBeSet)
    var fetchTodoByIdsResult: Result<[Todo], Error> = .failure(MockedError.valueNeedToBeSet)
    var storeResult: Result<[Todo], Error> = .failure(MockedError.valueNeedToBeSet)
    var deleteResult: Result<Void, Error> = .failure(MockedError.valueNeedToBeSet)
    
    func fetchTodoList() -> AnyPublisher<[Todo], Error> {
        add(.fetchTodoList)
        return fetchTodoListResult.publish()
    }
    
    func fetchTodo(by ids: [String]) -> AnyPublisher<[Todo], Error> {
        add(.fetchTodoByIds)
        return fetchTodoByIdsResult.publish()
    }
    
    func store(todoList: [TodoWebModel]) -> AnyPublisher<[Todo], Error> {
        add(.store(todoList: todoList))
        return storeResult.publish()
    }
    
    func delete(todo: Todo) -> AnyPublisher<Void, Error> {
        add(.delete(todo: todo))
        return deleteResult.publish()
    }
}
