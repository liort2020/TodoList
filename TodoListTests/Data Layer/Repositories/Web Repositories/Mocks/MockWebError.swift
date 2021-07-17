//
//  MockResponseError.swift
//  TodoListTests
//
//  Created by Lior Tal on 12/07/2021.
//

import XCTest
@testable import TodoList

enum MockWebError: Error {
    case request
    case response
}
