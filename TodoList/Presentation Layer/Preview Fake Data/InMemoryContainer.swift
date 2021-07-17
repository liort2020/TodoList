//
//  InMemoryContainer.swift
//  TodoList
//
//  Created by Lior Tal on 16/07/2021.
//

import Foundation
import CoreData

#if DEBUG
struct InMemoryContainer {
    static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        return container
    }()
}
#endif
