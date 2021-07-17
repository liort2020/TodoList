//
//  TodoListApp.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

@main
struct TodoListApp: App {
    private let diContainer = DIContainer.boot()
    
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .inject(diContainer)
        }
    }
}
