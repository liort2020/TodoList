//
//  TodoDBRepository.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation
import Combine

protocol TodoDBRepository {
    func fetchTodoList() -> AnyPublisher<[Todo], Error>
    func fetchTodo(by ids: [String]) -> AnyPublisher<[Todo], Error>
    func store(todoList: [TodoWebModel]) -> AnyPublisher<[Todo], Error>
    func delete(todo: Todo) -> AnyPublisher<Void, Error>
}

struct RealTodoDBRepository: TodoDBRepository {
    private let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    
    func fetchTodoList() -> AnyPublisher<[Todo], Error> {
        let fetchRequest = Todo.requestAllItems()
        return persistentStore
            .fetch(fetchRequest)
    }
    
    func fetchTodo(by ids: [String]) -> AnyPublisher<[Todo], Error> {
        let fetchRequest = Todo.requestItems(by: ids)
        return persistentStore
            .fetch(fetchRequest)
    }
    
    func store(todoList: [TodoWebModel]) -> AnyPublisher<[Todo], Error> {
        var publishers = [AnyPublisher<Todo, Error>]()
        
        todoList.forEach { model in
            let fetchRequest = Todo.requestItems(by: [model.id])
            
            let update = persistentStore
                .update(fetchRequest: fetchRequest) { item in
                    item.id = model.id
                    item.title = model.title
                } createNew: { context in
                    model.store(in: context)
                }
            publishers.append(update)
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func delete(todo: Todo) -> AnyPublisher<Void, Error> {
        guard let todoId = todo.id else {
            return Empty().eraseToAnyPublisher()
        }
        
        let fetchRequest = Todo.requestItems(by: [todoId])
        return persistentStore
            .delete(fetchRequest)
    }
}
