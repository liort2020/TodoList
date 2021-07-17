//
//  DIContainer+MockedInteractors.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

extension DIContainer.Interactors {
    static func mocked(todoInteractor: [MockedTodoInteractor.Action] = []) -> DIContainer.Interactors {
        DIContainer.Interactors(todoInteractor: MockedTodoInteractor(expectedActions: todoInteractor))
    }
}
