//
//  Todo+FetchRequest.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import CoreData

// MARK: - FetchRequest
extension Todo {
    static let entityName = "Todo"
    
    static func requestAllItems() -> NSFetchRequest<Todo> {
        let request = NSFetchRequest<Todo>(entityName: entityName)
        request.sortDescriptors = fetchRequestSort()
        return request
    }
    
    static func requestItems(by ids: [String]) -> NSFetchRequest<Todo> {
        let request = NSFetchRequest<Todo>(entityName: entityName)
        request.predicate = NSPredicate(format: "id IN %@", ids)
        request.sortDescriptors = fetchRequestSort()
        return request
    }
    
    static private func fetchRequestSort() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "id", ascending: false)]
    }
}

// MARK: - Store
extension TodoWebModel {
    // init Todo from Todo
    init?(managedObject: Todo) {
        guard let id = managedObject.id, let title = managedObject.title else { return nil }
        self.init(id: id, title: title)
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext) -> Todo {
        let todo = Todo(context: context)
        todo.id = id
        todo.title = title
        return todo
    }
}
