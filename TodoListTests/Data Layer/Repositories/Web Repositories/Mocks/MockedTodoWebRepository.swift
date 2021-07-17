//
//  MockedTodoWebRepository.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import Combine
@testable import TodoList

final class MockedTodoWebRepository: TestWebRepository, Mock, TodoWebRepository {
    enum Action: Equatable {
        case getAll
        case store(title: String)
        case delete(todo: Todo)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var getAllResponse: Result<[TodoWebModel], Error> = .failure(MockedError.valueNeedToBeSet)
    var updateResponse: Result<TodoWebModel, Error> = .failure(MockedError.valueNeedToBeSet)
    var addNewResponse: Result<TodoWebModel, Error> = .failure(MockedError.valueNeedToBeSet)
    var deleteResponse: Result<Void, Error> = .failure(MockedError.valueNeedToBeSet)
    
    func getAll() -> AnyPublisher<[TodoWebModel], Error> {
        add(.getAll)
        return getAllResponse.publish()
    }
    
    func store(title: String) -> AnyPublisher<TodoWebModel, Error> {
        add(.store(title: title))
        return addNewResponse.publish()
    }
    
    func delete(todo: Todo) -> AnyPublisher<Void, Error> {
        add(.delete(todo: todo))
        return deleteResponse.publish()
    }
}
