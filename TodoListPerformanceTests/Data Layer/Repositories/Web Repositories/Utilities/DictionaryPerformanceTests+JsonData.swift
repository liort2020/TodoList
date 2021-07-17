//
//  DictionaryPerformanceTests+JsonData.swift
//  TodoListPerformanceTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

final class JsonDataDictionaryPerformanceTests: XCTestCase {
    func test_retriveData_performance() {
        let jsonBody: [String: Any] = ["title": "My Title"]
        
        measure {
            let _ = try? jsonBody.retriveData()
        }
    }
}
