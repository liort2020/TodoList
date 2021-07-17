//
//  DIContainer.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import SwiftUI
import Combine

typealias AppStateSubject = CurrentValueSubject<AppState, Never>?

struct DIContainer {
    private(set) var appState: AppStateSubject?
    private(set) var interactors: Interactors?
    private static let baseURL = "https://todo-list-app1234.herokuapp.com"
    
    static func boot() -> DIContainer {
        let appState = CurrentValueSubject<AppState, Never>(AppState())
        
        let session = URLSession.shared
        let webRepositories = configureWebRepositories(using: session, appState: appState)
        let dbRepositories = configureDBRepositories(appState: appState)
        let interactors = configureInteractors(webRepositories: webRepositories, dbRepositories: dbRepositories, appState: appState)
        
        return DIContainer(appState: appState, interactors: interactors)
    }
    
    private static func configureWebRepositories(using session: URLSession, appState: AppStateSubject?) -> DIContainer.WebRepositories {
        let todoWebRepository = RealTodoWebRepository(session: session, baseURL: Self.baseURL)
        return DIContainer.WebRepositories(todoWebRepository: todoWebRepository)
    }
    
    private static func configureDBRepositories(appState: AppStateSubject?) -> DIContainer.DBRepositories {
        let persistentStore = CoreDataStack()
        let todoDBRepository = RealTodoDBRepository(persistentStore: persistentStore)
        return DIContainer.DBRepositories(todoDBRepository: todoDBRepository)
    }
    
    private static func configureInteractors(webRepositories: DIContainer.WebRepositories, dbRepositories: DIContainer.DBRepositories, appState: AppStateSubject?) -> DIContainer.Interactors {
        let todoInteractor = RealTodoInteractor(todoWebRepository: webRepositories.todoWebRepository, todoDBRepository: dbRepositories.todoDBRepository, appState: appState)
        return DIContainer.Interactors(todoInteractor: todoInteractor)
    }
}
