//
//  FakeTodoItems.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import Foundation

#if DEBUG
struct FakeTodoItems {
    private static func createFakeTodo(id: String, title: String) -> Todo {
        let todo = Todo(context: InMemoryContainer.container.viewContext)
        todo.id = id
        todo.title = title
        return todo
    }
    
    static var all: [Todo] {
        [createFakeTodo(id: "175", title: "Fix a Door 🚪"),
         createFakeTodo(id: "174", title: "Grocery Shopping"),
         createFakeTodo(id: "176", title: "Bake a Cake")]
    }
}
#endif
