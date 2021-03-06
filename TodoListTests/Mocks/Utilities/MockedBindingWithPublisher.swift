//
//  MockedBindingWithPublisher.swift
//  TodoListTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import TodoList

struct MockedBindingWithPublisher<Value> {
    let binding: Binding<Value>
    let publisher: AnyPublisher<[Value], Never>
    
    init(value: Value) {
        var value = value
        var updates = [value]
        binding = Binding<Value>(get: { value },
                                 set: { value = $0
                                        updates.append($0) })
        
        publisher = Future<[Value], Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                promise(.success(updates))
            }
        }
        .eraseToAnyPublisher()
    }
}
