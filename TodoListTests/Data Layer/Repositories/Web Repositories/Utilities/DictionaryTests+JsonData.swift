//
//  DictionaryTests+JsonData.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

final class JsonDataDictionaryTests: XCTestCase {
    func test_retriveData() {
        let jsonBody: [String: Any] = ["title": "My Title"]
        
        do {
            let data = try jsonBody.retriveData()
            XCTAssertNotNil(data)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}
