//
//  MockedModel.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

class MockedModel {
    static var testBundle = Bundle(for: MockedModel.self)
    static let mockedTodoListFileName = "mock_todo_list"
    static let mockedTodoFileName = "mock_todo"
    
    static func load() -> [TodoWebModel] {
        guard let url = testBundle.url(forResource: Self.mockedTodoListFileName, withExtension: "json") else { return [] }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([TodoWebModel].self, from: data)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return []
        }
    }
    
    static func getTodoListData() -> Data? {
        guard let url = testBundle.url(forResource: Self.mockedTodoListFileName, withExtension: "json") else { return nil }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func todoData() -> Data? {
        guard let url = testBundle.url(forResource: Self.mockedTodoFileName, withExtension: "json") else { return nil }

        do {
            return try Data(contentsOf: url)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
}
