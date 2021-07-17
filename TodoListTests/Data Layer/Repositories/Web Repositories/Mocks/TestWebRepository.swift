//
//  TestWebRepository.swift
//  TodoListTests
//
//  Created by Lior Tal on 22/03/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

class TestWebRepository: WebRepository {
    let bgQueue = DispatchQueue(label: "test_web_repository_queue")
    let session: URLSession = .mockedSession
    let baseURL = "https://test.com"
}
