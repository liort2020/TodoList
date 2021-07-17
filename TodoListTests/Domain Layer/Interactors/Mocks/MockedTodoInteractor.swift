//
//  MockedTodoInteractor.swift
//  TodoListTests
//
//  Created by Lior Tal on 22/03/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
@testable import TodoList

struct MockedTodoInteractor: Mock, TodoInteractor {
    enum Action: Equatable {
        case load
        case fetchAll
        case store(title: String)
        case update(todo: Todo)
        case delete(todo: Todo)
    }
    var actions: MockedList<Action>
    
    init(expectedActions: [Action]) {
        self.actions = .init(expectedActions: expectedActions)
    }
    
    func load(todoList: Binding<[Todo]>) {
        add(.load)
    }
    
    func fetchAll(todoList: Binding<[Todo]>) {
        add(.fetchAll)
    }
    
    func store(title: String, todoList: Binding<[Todo]>) {
        add(.store(title: title))
    }
    
    func update(todo: Todo, todoList: Binding<[Todo]>) {
        add(.update(todo: todo))
    }
    
    func delete(todo: Todo, todoList: Binding<[Todo]>) {
        add(.delete(todo: todo))
    }
}
