//
//  TodoWebModel+Mocked.swift
//  TodoListTests
//
//  Created by Lior Tal on 09/07/2021.
//

import XCTest
import CoreData
@testable import TodoList

//extension TodoWebModel {
class Mockiii {
//    lazy var testBundle = Bundle(for: type(of: self))
    static var testBundle = Bundle(for: Mockiii.self)
    static let mockedFileName = "mock_todo_list"
    
    static func loadMockedModel(using context: NSManagedObjectContext) -> [Todo]? {
        guard let url = testBundle.url(forResource: Self.mockedFileName, withExtension: "json") else {
            return nil
            
        }
        
        do {
//            let url = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: url)
            let todoWebModels = try JSONDecoder().decode([TodoWebModel].self, from: data)
            let fff = todoWebModels.map {
                $0.store(in: context)
            }
            return fff
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
}
