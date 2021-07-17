//
//  TodoWebRepository.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol TodoWebRepository: WebRepository {
    func getAll() -> AnyPublisher<[TodoWebModel], Error>
    func store(title: String) -> AnyPublisher<TodoWebModel, Error>
    func delete(todo: Todo) -> AnyPublisher<Void, Error>
}

struct RealTodoWebRepository: TodoWebRepository {
    let bgQueue = DispatchQueue(label: "todo_web_repository_queue")
    let session: URLSession
    let baseURL: String
    
    func getAll() -> AnyPublisher<[TodoWebModel], Error> {
        requestURL(endpoint: TodoEndpoint.getAll)
    }
    
    func store(title: String) -> AnyPublisher<TodoWebModel, Error> {
        requestURL(endpoint: TodoEndpoint.addNew(title))
    }
    
    func delete(todo: Todo) -> AnyPublisher<Void, Error> {
        requestURLWithoutReturningData(endpoint: TodoEndpoint.deleteItem(todo))
    }
}
