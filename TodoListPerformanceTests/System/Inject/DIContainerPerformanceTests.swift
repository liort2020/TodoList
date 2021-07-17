//
//  DIContainerPerformanceTests.swift
//  TodoListPerformanceTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

final class DIContainerPerformanceTests: XCTestCase {
    func test_boot_performance() {        
        measure {
            let _ = DIContainer.boot()
        }
    }
}
