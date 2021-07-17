//
//  TestWebRepository.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

class TestWebRepository: WebRepository {
    static let testURL = "https://test.com"
    
    let bgQueue = DispatchQueue(label: "test_web_repository_queue")
    let session: URLSession = .mockedSession
    let baseURL = testURL
}
