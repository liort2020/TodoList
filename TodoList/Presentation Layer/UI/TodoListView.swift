//
//  TodoListView.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI

struct TodoListView: View {
    @Environment(\.inject) private var inject: DIContainer
    @State private var todoList: [Todo]
    @State private var presentTextFieldAlert = false
    
    init(_ todoList: [Todo] = []) {
        _todoList = State(initialValue: todoList)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(todoList.enumerated()), id: \.element.id) { (index, todo) in
                    TodoCellView(todo: $todoList[index])
                }
                .onDelete(perform: delete)
            }
            .alert(isPresented: $presentTextFieldAlert,
                   TextFieldAlert(title: AlertTitles.alertTitle.rawValue,
                                  placeholder: AlertTitles.placeholderTitle.rawValue,
                                  primaryButtonTitle: AlertTitles.primaryButtonTitle.rawValue,
                                  secondaryButtonTitle: AlertTitles.secondaryButtonTitle.rawValue) { newText in
                    guard let text = newText else { return }
                    addNewItem(title: text)
                   })
            .navigationBarItems(trailing: ImageButton(buttonTapped: $presentTextFieldAlert,
                                                      buttonIcon: navigationBarButtonIcon,
                                                      buttonFont: navigationBarButtonFont))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(navigationBarTitle)
        }
        .onAppear {
            load()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: Constants
    private let navigationBarTitle = "Todo List"
    private let navigationBarButtonIcon = "plus"
    private let navigationBarButtonFont: Font = .title
    
    private enum AlertTitles: String {
        case alertTitle = "Add New Item"
        case placeholderTitle = "Enter Task"
        case primaryButtonTitle = "OK"
        case secondaryButtonTitle = "Cancel"
    }
}

// MARK: - Actions
extension TodoListView {
    private func load() {        
        // Load from database
        inject.interactors?.todoInteractor.load(todoList: $todoList)
        // Fetch from network
        inject.interactors?.todoInteractor.fetchAll(todoList: $todoList)
    }
    
    private func addNewItem(title: String) {
        inject.interactors?.todoInteractor.store(title: title, todoList: $todoList)
    }
    
    private func delete(at offsets: IndexSet) {
        if let itemToDelete = offsets.map({ todoList[$0] }).first {
            inject.interactors?.todoInteractor.delete(todo: itemToDelete, todoList: $todoList)
        }
        todoList.remove(atOffsets: offsets)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // preview light mode
            TodoListView(FakeTodoItems.all)
                .preferredColorScheme(.light)
            
            // preview dark mode
            TodoListView(FakeTodoItems.all)
                .preferredColorScheme(.dark)
            
            // preview right to left
            TodoListView(FakeTodoItems.all)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName(#"\.layoutDirection, .rightToLeft"#)
            
            // preview accessibility medium
            TodoListView(FakeTodoItems.all)
                .environment(\.sizeCategory, .accessibilityMedium)
        }
    }
}
