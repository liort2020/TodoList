//
//  DIContainerPerformanceTests+Inject.swift
//  TodoListPerformanceTests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
@testable import TodoList

final class InjectDIContainerPerformanceTests: XCTestCase {
    private var diContainer: DIContainer?
    
    override func setUp() {
        super.setUp()
        diContainer = DIContainer.boot()
    }
    
    func test_inject_container_to_view_performance() throws {
        let diContainer = try XCTUnwrap(diContainer)
        
        measure {
            let _ = EmptyView()
                .inject(diContainer)
        }
    }
    
    override func tearDown() {
        diContainer = nil
        super.tearDown()
    }
}
