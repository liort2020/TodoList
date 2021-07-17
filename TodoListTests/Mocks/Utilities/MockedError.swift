//
//  MockedError.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

enum MockedError: Swift.Error {
    case valueNeedToBeSet
}
