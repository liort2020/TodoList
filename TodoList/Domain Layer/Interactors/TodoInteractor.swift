//
//  TodoInteractor.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

protocol TodoInteractor {
    func load(todoList: Binding<[Todo]>)
    func fetchAll(todoList: Binding<[Todo]>)
    func store(title: String, todoList: Binding<[Todo]>)
    func delete(todo: Todo, todoList: Binding<[Todo]>)
}

class RealTodoInteractor: TodoInteractor {
    private let todoWebRepository: TodoWebRepository
    private let todoDBRepository: TodoDBRepository
    private let appState: AppStateSubject?
    private var subscriptions = Set<AnyCancellable>()
    
    init(todoWebRepository: TodoWebRepository, todoDBRepository: TodoDBRepository, appState: AppStateSubject?) {
        self.todoWebRepository = todoWebRepository
        self.todoDBRepository = todoDBRepository
        self.appState = appState
    }
    
    func load(todoList: Binding<[Todo]>) {
        todoDBRepository
            .fetchTodoList()
            .eraseToAnyPublisher()
            .sink { completion in
                if let error = completion.checkError() {
                    print(error.localizedDescription)
                }
            } receiveValue: { newTodoList in
                todoList.wrappedValue = newTodoList
            }
            .store(in: &subscriptions)
    }
    
    func fetchAll(todoList: Binding<[Todo]>) {
        todoWebRepository
            .getAll()
            .flatMap { [todoDBRepository] in
                // Save to database
                todoDBRepository.store(todoList: $0)
            }
            .eraseToAnyPublisher()
            .sink { completion in
                if let error = completion.checkError() {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] _ in
                self?.load(todoList: todoList)
            }
            .store(in: &subscriptions)
    }
    
    func store(title: String, todoList: Binding<[Todo]>) {
        guard !title.isEmpty else { return }
        
        todoWebRepository
            .store(title: title)
            .eraseToAnyPublisher()
            .flatMap { [todoDBRepository] in
                // Save to database
                todoDBRepository.store(todoList: [$0])
            }
            .sink { completion in
                if let error = completion.checkError() {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] _ in
                self?.load(todoList: todoList)
            }
            .store(in: &subscriptions)
    }
    
    func delete(todo: Todo, todoList: Binding<[Todo]>) {
        todoWebRepository
            .delete(todo: todo)
            .eraseToAnyPublisher()
            .flatMap { [todoDBRepository] in
                // Delete from database
                todoDBRepository.delete(todo: todo)
            }
            .sink { completion in
                if let error = completion.checkError() {
                    print(error.localizedDescription)
                }
            } receiveValue: { }
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
}
